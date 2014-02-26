import java.io.*;

// import ANTLR's runtime libraries
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.runtime.atn.PredictionMode;

public class GollyRleReader
{
  public class BailGollyRleLexer extends GollyRleLexer
  {
    public BailGollyRleLexer(CharStream input)
    {
      super(input);
    }
    public void recover(LexerNoViableAltException e)
    {
      throw new RuntimeException(e); // Bail out
    }
  }

  public boolean parseFile(String file)
  {
    boolean validFile = false;
    try
    {
      FileInputStream fis = new FileInputStream(file);
      ANTLRInputStream input = new ANTLRInputStream(fis);
      BailGollyRleLexer lexer = new BailGollyRleLexer(input);
      CommonTokenStream tokens = new CommonTokenStream(lexer);
      GollyRleParser parser = new GollyRleParser(tokens);
      parser.getInterpreter().setPredictionMode(PredictionMode.SLL); // faster
      parser.removeErrorListeners();
      parser.setErrorHandler(new BailErrorStrategy());

      try
      {
        ParseTreeWalker walker = new ParseTreeWalker();
        GollyRleFileLoader loader = new GollyRleFileLoader();
        ParseTree tree = parser.rle();
        walker.walk(loader, tree);
//	GollyRleConfiguration config = loader.getConfiguration();
//	config.checkMatrixIntegrity();
	validFile = true;
      }
/*    catch (RuntimeException e)
      {
        // e.printStackTrace();
        System.err.println("Exception caught: " + e.getCause());
      }
*/    catch (RuntimeException ex)
      {
        // try to recover from a RecognEx
        System.err.println("Exception caught: " + ex.getCause());
        if (ex.getClass() == RuntimeException.class &&
            ex.getCause() instanceof RecognitionException)
        {
          // The BailErrorStrategy wraps the RecognitionExceptions in
          // RuntimeExceptions so we have to make sure we're detecting
          // a true RecognitionException not some other kind
          tokens.reset(); // rewind input stream
          // back to standard listeners/handlers
          parser.addErrorListener(ConsoleErrorListener.INSTANCE);
          parser.setErrorHandler(new DefaultErrorStrategy());
          parser.getInterpreter().setPredictionMode(PredictionMode.LL); // try full LL(*)
          parser.rle();
        }
      }

    }
    catch (IOException e)
    {
      System.err.println("ERROR: " + e.getMessage());
    }

    return validFile;
  }

  public boolean parseString(String text)
  {
    boolean validString = false;
    return validString;
  }

	public static void main(String[] args) throws Exception
	{
		if(args.length == 0)
		{
			System.err.println("Syntax: GollyRleReader <golly_ca.rle>");
			System.exit(1);
		}
		else
		{
		  GollyRleReader reader = new GollyRleReader();
		  boolean validFile = reader.parseFile(args[0]);
		  
		  System.out.println("FILE is " + (validFile? "VALID": "NOT VALID"));
		}
	}
}

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

  public GollyRleConfiguration parseFile(String file)
  {
    GollyRleConfiguration config = new GollyRleConfiguration();
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
        config = loader.getConfiguration();
        System.out.println("Golly RLE format validation: PASSED");
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
        System.out.println("Golly RLE format validation: FAILED");
      }

    }
    catch (IOException e)
    {
      System.err.println("ERROR: " + e.getMessage());
    }

    return config;
  }

  public boolean parseString(String text)
  {
    boolean validString = false;
    return validString;
  }

  public static void compareMatrices(GollyRleConfiguration config, String manualMatrixFile) throws IOException
  {
    manualMatrixFile += ".txt"; // rude temporary choice
    GollyMatrixReader manualMatrix = new GollyMatrixReader(manualMatrixFile);
    manualMatrix.createConfig();
    boolean matchingMatrices = manualMatrix.isManualMatrixEqual(config);
    System.out.print("Golly RLE decoded matrix VS handwritten one: ");
    if (matchingMatrices) System.out.println("MATRICES MATCH");
    else System.out.println("MATRICES DON'T MATCH");
  }

  public static void main(String[] args) throws Exception
  {

    if(args.length == 0)
    {
      System.err.println("For a list of the available commands type: GollyRleReader -h");
      System.exit(1);
    }
    else
    {
      String actualFile = args[0];
      if (actualFile.equals("-h"))
      {
        System.out.println("Syntax\t: GollyRleReader <FILE> [OPTIONS]\n\n"
                         + " <FILE> is a mandatory field;\n"
                         + " [OPTIONS] are optional fields:\n"
                         + "    -d   : draw the matrix\n"
                         + "    -c   : parse FILE(.RLE) and validate the equivalent handwritted FILE(.RLE.TXT) file in the same dir\n");
      }
      else
      {
        GollyRleReader reader = new GollyRleReader();
        GollyRleConfiguration config = reader.parseFile(actualFile);

        // Perform other actions if requested
        if (args.length > 1)
        {
          boolean alreadyDrown = false;
          boolean alreadyCompared = false;
          for (int i = 1; i < args.length; i++)
          {
            switch(args[i])
            {
              case "-d":
              {
                if (!alreadyDrown)
                {
                  config.drawMatrix();
                  alreadyDrown = true;
                }
                break;
              }
              case "-c":
              {
                if (!alreadyCompared)
                {
		  compareMatrices(config, actualFile);
                  alreadyCompared = true;
                }
                break;
              }
            }
          }
        }
        //System.out.println("FILE is " + (validFile? "VALID": "NOT VALID"));
      }
    }
  }

}

import java.io.*;

// import ANTLR's runtime libraries
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.runtime.atn.PredictionMode;

public class GollyRleReader
{
	public static class BailGollyRleLexer extends GollyRleLexer
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

	public static void main(String[] args) throws Exception
	{
		if(args.length == 0)
		{
			System.err.println("Syntax: GollyRleReader <golly_ca.rle>");
			System.exit(1);
		}
		else
		{
			try
			{
				FileInputStream fis = new FileInputStream(args[0]);
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
				  
				  //System.out.println("File is valid!");
				  //ParseTree tree = parser.rle(); // begin parsing at init rule
				  //System.out.println(tree.toStringTree(parser));// print LISP-style tree
				}
				catch (RuntimeException e)
				{
					//e.printStackTrace();
					System.err.println("ERROR: File is NOT in a valid Golly RLE format!");
				}
/*				catch (RuntimeException ex)
				{
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
*/
			}
			catch (IOException e)
			{
				System.err.println("ERROR: " + e.getMessage());
			}
		}
	}
}

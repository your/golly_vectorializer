import java.io.*;

// import ANTLR's runtime libraries
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class golly_rleReader
{
	public static class BailGolly_rleLexer extends golly_rleLexer {
        public BailGolly_rleLexer(CharStream input) { super(input); }
        public void recover(LexerNoViableAltException e) {
            throw new RuntimeException(e); // Bail out
        }
    }

	public static void main(String[] args) throws Exception
	{
		if(args.length == 0)
		{
			System.err.println("Syntax: golly_rleReader <golly_ca.rle>");
			System.exit(1);
		}
		else
		{
			try
			{
				FileInputStream fis = new FileInputStream(args[0]);
				ANTLRInputStream input = new ANTLRInputStream(fis);
				BailGolly_rleLexer lexer = new BailGolly_rleLexer(input);
				CommonTokenStream tokens = new CommonTokenStream(lexer);
				golly_rleParser parser = new golly_rleParser(tokens);
				parser.removeErrorListeners();
				parser.setErrorHandler(new BailErrorStrategy());

				try
				{
					parser.rle();
					System.out.println("File is valid!");
					//ParseTree tree = parser.rle(); // begin parsing at init rule
					//System.out.println(tree.toStringTree(parser));// print LISP-style tree
				}
				catch (RuntimeException e)
				{
					System.err.println("File is NOT valid!");
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
				// Create a generic parse tree walker that can trigger callbacks
				//ParseTreeWalker walker = new ParseTreeWalker();

				// Walk the tree created during the parse, trigger callbacks
				//walker.walk(new golly_rleFileValidation(), tree);
				

				//System.out.println(); // print a \n after translation
			}
			catch (IOException e)
			{
				System.err.println("Error: " + e.getMessage());
			}
		}
	}
}

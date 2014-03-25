import java.io.*;
import java.util.*;

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
  
  public GollyRleConfiguration parseString(String data) throws RuntimeException, IOException
  {
    ANTLRInputStream input = new ANTLRInputStream(data);
    return parseData(input);
  }
  
  public GollyRleConfiguration parseFile(String file) throws RuntimeException, IOException
  {
    FileInputStream fis = new FileInputStream(file);
    ANTLRInputStream input = new ANTLRInputStream(fis);
    return parseData(input);
  }
  
  /** Parse a given file and return its configuration */
  private GollyRleConfiguration parseData(ANTLRInputStream input) throws RuntimeException, IOException
  {
    GollyRleConfiguration config = null;
    
    /** Setting up ANTLR */
    
    BailGollyRleLexer lexer = new BailGollyRleLexer(input);
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    GollyRleParser parser = new GollyRleParser(tokens);
    parser.getInterpreter().setPredictionMode(PredictionMode.SLL); // faster mode
    parser.removeErrorListeners();
    parser.setErrorHandler(new BailErrorStrategy());
    
    /** Parsing tree */
    ParseTreeWalker walker = new ParseTreeWalker();
    GollyRleFileLoader loader = new GollyRleFileLoader();
    ParseTree tree = parser.rle();
    walker.walk(loader, tree);
    
    /** Getting config */
    config = loader.getConfiguration();
    return config;
  }

  // TODO: move this method to batcher
  // public static void compareMatrices(GollyRleConfiguration config, String manualMatrixFile) throws IOException
  // {
  //   manualMatrixFile += ".txt"; // rude temporary choice
  //   ArrayList<ArrayList<Integer>> newMatrix = new ArrayList<ArrayList<Integer>>();
  //   boolean ioError = false;
  //   try
  // 	{
  // 	    GollyMatrixReader manualMatrix = new GollyMatrixReader(manualMatrixFile);
  // 	    newMatrix = manualMatrix.parseMatrixFile();
  // 	}
  //   catch(IOException e)
  // 	{
  // 	    System.out.println("ERROR: " + e.getMessage());
  // 	    ioError = true;
  // 	}
  //   finally
  // 	{
  // 	    if (!ioError)
  // 		{
  // 		    GollyRleConfiguration manualConfig = new GollyRleConfiguration(newMatrix);
  // 		    boolean matchingMatrices = config.equalsToMatrix(manualConfig);
  // 		    System.out.print("Golly RLE decoded matrix VS handwritten one: ");
  // 		    if (matchingMatrices) System.out.println("MATRICES MATCH");
  // 		    else System.out.println("MATRICES DON'T MATCH");
  // 		}
  // 	    else
  // 		{
  // 		    System.out.println("ERROR: I was not able to compare matrices!");
  // 		}
  // 	}
  // }

  public static void main(String[] args) throws Exception
  {
    if(args.length == 0)
    {
      System.err.println("Syntax: GollyRleReader <gollyca.rle>");
      System.exit(1);
    }
    else
    {
      String actualFile = args[0];
      GollyRleReader reader = new GollyRleReader();
      GollyRleConfiguration config = reader.parseFile(actualFile);
    }
  }
  
}

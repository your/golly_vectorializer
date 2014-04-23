import java.nio.file.*;
import java.io.File;
import java.io.PrintWriter;
import java.io.FileNotFoundException;

public class GollyFileSaver
{
  private static final char startingPrefix = 'p';
  private static final char startingActiveState = 'A';
  private static final char inactiveState = '.';
  private static final int states = 24;
	
  private String getInnerLetter(int reminder)
  {
    char letter = (char)(reminder + startingActiveState - 1);
    return String.valueOf(letter);
  }
	
  private String translateCellState(String prefix, String letter)
  {
    return prefix + letter;
  }
	
  private String getPrefixLetter(int state)
  {
    String prefix = "";
    if(state > 0)
    {
      char prefixChar = (char)(startingPrefix + state - 1);
      prefix = String.valueOf(prefixChar);
    }
    return prefix;
  }
	
  private String translateCellState(int state)
  {
    String translatedState = null;

    if(state > 0)
    {
      int reminder = state % states;
      int prefix = state / states;
                
      String prefixString = getPrefixLetter(prefix);
      String innerLetter = getInnerLetter(reminder);
      translatedState = prefixString + innerLetter;
    }
    else
    {
      translatedState = ".";
    }
 
    return translatedState;
  }
	
  public void exportConfigurationToRle(GollyRleConfiguration config, String path)
  {
    try
    {
      int matrixWidth = config.getMatrixWidth();
      int matrixHeight = config.getMatrixHeight();
      String rule = config.getRule();
		
      File outputFile = new File(path);
      PrintWriter writer = new PrintWriter(outputFile);
		
      writer.println("x = " + matrixWidth + ", " +
		     "y = " + matrixHeight + ", " +
		     "rule = " + rule);
							
      // writer.println("\r\n");
							
      for (int i = 0; i < matrixHeight; ++i)
      {
	for (int j = 0; j < matrixWidth; ++j)
	{
	  int state = config.getCellState(i, j);
	  String stateString = translateCellState(state);
	  writer.print(stateString);
	}
	writer.print("$");
      }
		
      writer.print("!\r\n");
		
      writer.close();
    }
    catch(FileNotFoundException e)
    {
      System.out.println("Cannot open file " + path);
      e.printStackTrace();
    }
  }

}





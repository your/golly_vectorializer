import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class GollyRleManualInput
{
  GollyRleConfiguration inputConfig;

  GollyRleManualInput()
  {
    this.inputConfig = new GollyRleConfiguration();
  }

  public GollyRleConfiguration fillManualMatrix() throws IOException
  {
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    System.out.print("MATRIX WIDTH --> ");
    int width = readIntFromInput(br);
    inputConfig.setMatrixWidth(width);

    System.out.print("MATRIX HEIGHT --> ");
    int height = readIntFromInput(br);
    inputConfig.setMatrixHeight(height);

    inputConfig.initMatrix();

    System.out.println("### MATRIX CONTENT ### ");
    for (int i = 0; i < height; i++)
    {
      System.out.printf("[ROW NR. %d]\n", i+1); 
      inputConfig.addMatrixRow();
      for (int j = 0; j < width; j++)
      {
        System.out.printf("--> COL NR. %d\n", j+1);
        int cell = readIntFromInput(br);
        inputConfig.addMatrixCell(cell);
      }
    }
   return this.inputConfig;
  }

  public int readIntFromInput(BufferedReader br) throws IOException
  {
    int inputInt = 0;
    boolean foundAnInteger = false;
    do
    {
      System.out.print("Enter Integer:");
      try
      {
        inputInt = Integer.parseInt(br.readLine());
        foundAnInteger = true;
      }
      catch(NumberFormatException nfe)
      {
        System.err.println("Invalid Format!");
      }
      finally
      {
        if (!foundAnInteger) continue;
      }
    } while(!foundAnInteger);
   return inputInt;
  }
}


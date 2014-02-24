import java.util.*;

public class GollyRleConfiguration
{
  /******* members *********/
  private ArrayList<String> errors;
  private int matrixWidth;
  private int matrixHeight;
  private int cellState;
  private String rule;
  private ArrayList<ArrayList<Integer>> matrix;

  private static final char startingPrefix = 'p';
  private static final char startingActiveState = 'A';
  private static final int states = 24;

  public static final String voidMult = "1";
  public static final String voidPrefix = "None";

  /******* constructors *********/
  GollyRleConfiguration()
  {
    this.errors = new ArrayList<String>();
    this.matrix = new ArrayList<ArrayList<Integer>>();
    this.cellState = 0; //default
  }

  /******* accessors *********/
  public void setMatrixWidth(int width)
  {
    this.matrixWidth = width;
  }

  public void setMatrixHeight(int height)
  {
    this.matrixHeight = height;
  }

  public void setCellState(int cellState)
  {
    this.cellState = cellState;
  }

  public int getMatrixWidth()
  {
    return this.matrixWidth;
  }

  public int getMatrixHeight()
  {
    return this.matrixHeight;
  }

  public int getCellState()
  {
    return this.cellState;
  }

  /******* utilities *********/
  public void drawMatrix()
  {
    for (List<Integer> list : this.matrix)
    {
      for (Integer i : list)
      {
        System.out.print(i + " "); 
      }
      System.out.println();
    }
  }

  public void addMatrixRow()
  {
    ArrayList<Integer> row = new ArrayList<Integer>();
    matrix.add(row);
  }

  public void addMatrixCell(int index, int value)
  {
    ArrayList<Integer> row = matrix.get(index);
    row.add(value);
  }

  public void addMatrixCell(int value)
  {
    /* assuming there is at least one row */
    int lastRow = matrix.size() - 1;
    addMatrixCell(lastRow, value);
  }
  
  public void addEmptyMatrixRow(int columns)
  {
    ArrayList<Integer> row = new ArrayList<Integer>();
    for(int i = 0; i < columns; ++i)
    {
      /* adding zero values */
      row.add(0);
    }
    matrix.add(row);
  }

  public int translatePrefix(String prefix)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char p = prefix.charAt(0);
    return p - startingPrefix + 1;
  }

  public int translateCellState(String state)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char s = state.charAt(0);
    return s - startingActiveState + 1;
  }

  public int translateCellState(String prefix, String state)
  {
    int p = 0;
    int c = translateCellState(state);

    /* If prefix is not void, translate it */
    if (!prefix.equals(voidPrefix))
    {
      p = translatePrefix(prefix);
    }

    return p * states + c;
  }
}
import java.util.*;

public class GollyRleConfiguration
{
  /******* members *********/
  private int matrixWidth;
  private int matrixHeight;
  private int cellState;
  private String rule;
  private ArrayList<ArrayList<Integer>> matrix;

  // public static final String voidMult = "1";
  // public static final String voidPrefix = "None";

  /******* constructors *********/
  GollyRleConfiguration()
  {
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

  /********** config checks ***********/
  public int checkMatrixHeight()
  {
    /* Exit codes:
       0 : height exactly matched
       1 : smaller than expected matrix built
      -1 : larger than expected matrix built
     */
    int result;
    int arrayListRows = matrix.size();

    if (arrayListRows == this.matrixHeight)
    {
      result = 0;
    }
    else
    {
      if (arrayListRows < this.matrixHeight)
      {
        result = 1;
      }
      else
      {
        result = -1;
      }
    }
    return result;
  }

  public ArrayList<Integer> checkMatrixWidth()
  {
    /* Will return an ArrayList with exit codes for every row */
    int arrayListRows = matrix.size();
    ArrayList<Integer> rowsWidth = new ArrayList<Integer>();

    for (int i = 0; i < arrayListRows; ++i)
    {
      int result;
      ArrayList<Integer> currentArrayListRow = matrix.get(i);
      int currentRowWidth = currentArrayListRow.size();

      if (currentRowWidth == this.matrixWidth)
      {
        result = 0;
      }
      else
      {
        if (currentRowWidth < this.matrixWidth)
        {
          result = 1;
        }
        else
        {
          result = -1;
        }
      }
      rowsWidth.add(result);
    }
   return rowsWidth;
  }

  public void checkMatrixIntegrity()
  {
    int heightIntegrity = checkMatrixHeight();
    ArrayList<Integer> widthIntegrity = checkMatrixWidth();

    int rowsExact = 0;
    int rowsSmaller = 0;
    int rowsLarger = 0;

    boolean caughtERows = false;
    boolean caughtSRows = false;
    boolean caughtLRows = false;

    for (int i = 0; i < widthIntegrity.size(); ++i)
    {
      int currentRow = widthIntegrity.get(i);
      switch(currentRow)
      {
        case 0:
        {
          rowsExact++;
          caughtERows = true;
          break;
        }
        case 1:
        {
          rowsSmaller++;
          caughtSRows = true;
          break;
        }
        case -1:
        {
          rowsLarger++;
          caughtLRows = true;
          break;
        }
      }
    }
    System.out.println("#### MATRIX INTEGRITY RESULTS ####");
    System.out.println("---> Detected COLS: " + (heightIntegrity==0?("[Y] EXACT")
                                               :(heightIntegrity<0?"[?] SMALLER than expected"
                                                                  :"[!] LARGER than expected")));

    System.out.println("---> Detected ROWS: " + (caughtERows?("[Y] EXACT: "+rowsExact+" "):"")
                                              + (caughtSRows?("[?] SMALLER: "+rowsSmaller+" "):"")
                                              + (caughtLRows?("[!] LARGER: "+rowsLarger+" "):""));
  }
}

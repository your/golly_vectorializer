import java.util.*;
import java.lang.Math;

public class GollyRleConfiguration implements java.io.Serializable
{
  /******* members *********/
  private int matrixWidth;
  private int matrixHeight;
  private int cellState;
  private String rule;
  private int [][] matrix;
  private int actualRow;
  private int actualCol;

  /******* constructors *********/
  GollyRleConfiguration()
  {
    this.cellState = 0; //default
  }

  GollyRleConfiguration(ArrayList<ArrayList<Integer>> newMatrix)
  {
    int actualRow = 0;
    int actualCol = 0;
    this.matrixHeight = newMatrix.size();
    this.matrixWidth = newMatrix.get(0).size();
    this.matrix = new int[this.matrixHeight][this.matrixWidth];
    for (List<Integer> cellList : newMatrix)
    {
      this.matrixWidth = cellList.size();
      for (Integer cellState : cellList)
      {
	  this.matrix[actualRow][actualCol] = cellState;
	  actualCol++;
      }
      actualRow++;
      actualCol = 0;
    }
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
  
  public void setCellState(int i, int j, int state)
  {
    matrix[i][j] = state;
  }
  
  public void setRule(String rule)
  {
    this.rule = rule;
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

  public String getRule()
  {
    return rule;
  }

  public int getCellState(int row, int col)
  {
    return this.matrix[row][col];
  }

  public void incrementState(int i, int j)
  {
    matrix[i][j]++;
    if(matrix[i][j] > 255)
    {
      matrix[i][j] = 255;
    }
  }

  public void decrementState(int i, int j)
  {
    matrix[i][j]--;
    if(matrix[i][j] < 0)
    {
      matrix[i][j] = 0;
    }
  }
  
  /******* utilities *********/
  public boolean equalsToMatrix(GollyRleConfiguration newConfig)
  {
    boolean result = false;
    int newHeight = newConfig.getMatrixHeight();
    int newWidth = newConfig.getMatrixWidth();

    if (matrixHeight != newHeight | matrixWidth != newWidth)
    {
      result = false;
    }
    else
    {
      for (int i = 0; i < matrixHeight; i++)
      {
        for (int j = 0; j < matrixWidth; j++)
        {
          int matrixCellState = matrix[i][j];
          int newMatrixCellState = newConfig.getCellState(i,j);
          if (matrixCellState != newMatrixCellState)
          {
            result = false;
          }
          else
          {
            result = true;
          }
	  if (result == false)
	  {
	    break;
	  }
        }
        if (result == false)
        {
          break;
        }
      }
    }
    return result;
  }

  public void drawMatrix()
  {
    for (int i = 0; i < this.matrixHeight; ++i)
    {
      for (int j = 0; j < this.matrixWidth; ++j)
      {
        System.out.print(this.matrix[i][j] + " ");
      }
      System.out.println();
    }
  }

  public void initMatrix()
  {
    this.matrix = new int[this.matrixHeight][this.matrixWidth];
    this.actualRow = -1;
    this.actualCol = 0;
  }

  public void addMatrixRow()
  {
    this.actualCol = 0;
    this.actualRow++;
  }

  public void addMatrixCell(int value)
  {
    /* assuming there is at least one row */
    // System.out.println("Row: " + actualRow + " | Col: " + actualCol + " : value " + value);
    this.matrix[this.actualRow][this.actualCol] = value;
    this.actualCol++;
  }

  public void addEmptyMatrixRow(int times)
  {
    for (int i = 0; i < times; ++i)
    {
      addMatrixRow();
      // for (int j = 0; j < this.matrixWidth; ++j)
      // {
      //   addMatrixCell(0);
      // }
    }
  }
  
  /* creating a scaled matrix configuration 
     NB: the algorithm works for integer valuess > 1 (=1 it behaves like a copy constructor) 
     */
  public GollyRleConfiguration newScaledConfiguration(float scaleFactor)
  {
    GollyRleConfiguration scaledConfig = new GollyRleConfiguration();
    scaledConfig.setMatrixHeight((int)(this.matrixHeight * scaleFactor));
    scaledConfig.setMatrixWidth((int)(this.matrixWidth * scaleFactor));
    
    scaledConfig.initMatrix();
    scaledConfig.setRule(this.rule);
    
    /* saving all the states */
    for(int i = 0; i < matrixHeight; ++i)
    {
      /* get the scaled matrix row index */
      int si = (int)(i * scaleFactor);
      for(int j = 0; j < matrixWidth; ++j)
      {
        /* same goes for the col index */
        int sj = (int)(j * scaleFactor);
        
        /* now copying all the states in the scaleFactor X scaleFactor square */
        for(int ki = si; ki < si + Math.ceil(scaleFactor); ++ki)
        {
          for(int kj = sj; kj < sj + Math.ceil(scaleFactor); ++kj)
          {
            scaledConfig.setCellState(ki, kj, matrix[i][j]);
          }
        }
      }
    }
    
    return scaledConfig;
  }

  static public GollyRleConfiguration newEmptyConfiguration(int height,
							    int width)
  {
    GollyRleConfiguration config = new GollyRleConfiguration();
    config.setMatrixHeight(height);
    config.setMatrixWidth(width);
    config.initMatrix();
    config.setRule("Custom"); /* we shall put a valid rule name if we want to export */
    
    return config;
  }

  /*
    DEPRECATED: use the colorAssignment in the settings
    creating a new random configuration changing only the active cell states */
  public GollyRleConfiguration newRandomStateConfiguration(CategoricalDistribution distribution)
  {
    GollyRleConfiguration randomConfig = new GollyRleConfiguration();
    randomConfig.setMatrixHeight(this.matrixHeight);
    randomConfig.setMatrixWidth(this.matrixWidth);
    
    randomConfig.initMatrix();
    randomConfig.setRule(this.rule);

    int state = 0;
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
	/* cell is active */
	if(matrix[i][j] > 0)
	{
	  /* get a random state */
	  state = distribution.nextValue();
	}
	else
	{
	  state = 0;
	}
      
	randomConfig.setCellState(i, j, state);
      }
    }
    return randomConfig;
  }

  /********** config checks ***********/
/*public int checkMatrixHeight()
  {
     //  Exit codes:
     //  0 : height exactly matched
     //  1 : smaller than expected matrix built
     // -1 : larger than expected matrix built

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
    // Will return an ArrayList with exit codes for every row
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
  }*/
}

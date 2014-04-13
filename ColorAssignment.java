import java.util.Queue;
import java.util.LinkedList;

public class ColorAssignment
{
  /*
    colors are assigned as a matrix of integers:
    a negative integer means there is no color (usually -1)
    a positive or zero integer represents a code for a color
    (for example an index for a ColorPalette).
    The color for inactive cells is stored in another var
  */
  int matrixHeight;
  int matrixWidth;
  int [][] matrix;

  /* hoping this will never gets coded */
  private static final int unseen = Integer.MIN_VALUE;
  // ColorPalette palette;
  // int inactiveCellColor;

  /* TODO: hierarchize ctors */
  // public ColorAssingment(int height,
  //                        int width
  // 			 //,
  //                        // ColorPalette colors,
  // 			 // int inactiveColor
  //   )
  // {
  //   initMatrix(height, width);
  //   // palette = colors;
  //   // inactiveCellColor = inactiveColor;
  // }

  public ColorAssignment(int height,
                         int width
			 // ,
                         // ColorPalette colors
    )
  {
    initMatrix(height, width);
    // palette = colors;
  }
  
  public ColorAssignment(GollyRleConfiguration config
			 // , ColorPalette colors
    )
  {
    initMatrix(config.getMatrixHeight(), config.getMatrixWidth());
    /* copying the config each state values - 1 becomes a code value */
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
	matrix[i][j] = config.getCellState(i, j) - 1;
      }
    }
    // palette = colors;
  }

  private void initMatrix(int height, int width)
  {
    matrixHeight = height;
    matrixWidth = width;
    matrix = new int [matrixHeight][matrixWidth];
     /* setting all to 0 by default */
  }

  public void setColorCode(int i, int j, int code)
  {
    matrix[i][j] = code;
  }

  // public void setColor(int index, int color)
  // {
  //   palette.setColor(index, color);
  // }

  public int getColorCode(int i, int j)
  {
    return matrix[i][j];
  }

  public void nextColor(int i, int j)
  {
    matrix[i][j]++;
  }

  public void previousColor(int i, int j)
  {
    matrix[i][j]--;
    // this block inhibits staus decrement once reached latest state
    // commenting out for now
    // if(matrix[i][j] < -1)
    // {
    //   matrix[i][j] = -1;
    // }
  }

  // public int getColor(int i, int j)
  // {
  //   int code = matrix[i][j];
  //   int color;
  //   if(code > 0)
  //   {
  //     color = palette.getColor(code);
  //   }
  //   else
  //   {
  //     color = inactiveCellColor;
  //   }
  //   return color;
  // }
  
  // public int getColor(int index)
  // {
  //   return palette.getColor(index);
  // }

  // public void setInactiveCellColor(int color)
  // {
  //   inactiveCellColor = color;
  // }

  // public int getInactiveCellColor()
  // {
  //   return inactiveCellColor;
  // }

  // public void setColorProbability(int index, double prob)
  // {
  //   palette.setColorProbability(index, prob);
  // }

  /* cloning and randomizing */
  public ColorAssignment newRandomColorAssignment(CategoricalDistribution distribution)
  {
    ColorAssignment randomAssignment = new ColorAssignment(matrixHeight, matrixWidth);
    randomAssignment.copyAssignment(this);
    randomAssignment.shuffle(distribution);
    
    return randomAssignment;
  }

  /*  random shuffles the colors assigned */
  public void shuffle(CategoricalDistribution distribution)
  {
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
        /* cell is active */
        if(matrix[i][j] >= 0)
        {
          /* get a random state */
          matrix[i][j] = distribution.nextValue();
        }
      }
    }
  }

  public void copyAssignment(ColorAssignment assignment)
  {
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
	matrix[i][j] = assignment.getColorCode(i, j);
      }
    }
  }

  /* graph connected neighbours expansion */
  private void enqueueNeighbours(ColorAssignment original,
				 int centerX,
				 int centerY,
				 int windowRadius,
				 int code,
				 Queue<Pair<Integer, Integer>> neighbours)
  {
    int startX = (centerX - windowRadius) >= 0 ? centerX - windowRadius : 0;
    int startY = (centerY - windowRadius) >= 0 ? centerY - windowRadius : 0;
    int endX = (centerX + windowRadius) < matrixHeight ?
      centerX + windowRadius : matrixHeight - 1;
    int endY = (centerY + windowRadius) < matrixWidth ?
      centerY + windowRadius : matrixWidth - 1;


    // System.out.println("win " + startX + " " + startY + " " + endX + " " + endY);
    /* cycling through the cells in the window */
    for(int i = startX; i <= endX; ++i)
    {
      for(int j = startY; j <= endY; ++j)
      {
	// System.out.println("-- " + i + " " + j + " -- " + original.getColorCode(i, j) +	  matrix[i][j]);
	/* if the cell is active and not seen */
	if(original.getColorCode(i, j) >= 0 &&
	   matrix[i][j] == unseen)
	{
	  /* color the cell and mark it as seen */
	  // System.out.println("coloring code " + code);
          matrix[i][j] = code;
	  if(i != centerX || j != centerY)
	  {
	    // System.out.println("adding neigh " + i + " " +  j);
	    neighbours.add(new Pair<Integer, Integer>(i, j));
	  }
	}
      }
    }
    // System.out.println("in list " + neighbours.size());
  }

  /* graph search */
  private void colorConnectedNeighbours(ColorAssignment originalAssignment,
					int startX,
					int startY,
					int windowRadius,
					int randomCode)
  {
    /* creating a queue */
    Queue<Pair<Integer, Integer>> neighboursList =
      new LinkedList<Pair<Integer, Integer>>();
    neighboursList.add(new Pair<Integer, Integer>(startX, startY));
    
    while(!neighboursList.isEmpty())
    {
      /* retrieve coordinates for the current cell */
      Pair<Integer, Integer> coordinates =
	neighboursList.remove();
      int i = coordinates.getLeft();
      int j = coordinates.getRight();
      
      
      // System.out.println("coloring " + randomCode + " " + i + " " +  j);
      /* expand all the neighbours */
      enqueueNeighbours(originalAssignment,
			i,
			j,
			windowRadius,
			randomCode,
			neighboursList);
      // System.out.println("in list " + neighboursList.size());
    }
  }
  
  public ColorAssignment newRandomLocalColorAssignment(CategoricalDistribution distribution,
						       int windowRadius)
  {
    ColorAssignment randomAssignment = new ColorAssignment(matrixHeight, matrixWidth);

    randomAssignment.shuffleLocal(this,
				  distribution,
				  windowRadius);

    
    return randomAssignment;
  }

  public void shuffleLocal(ColorAssignment original,
			   CategoricalDistribution distribution,
			   int windowRadius)
  {
    /* setting all unseen values  */
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
        // setColorCode(i, j, unseen);
	matrix[i][j] = unseen;
      }
    }

    /* enumerating all the cells */
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
        /* if the cell is active */
        // if(matrix[i][j] >= 0)
	int originalCode = original.getColorCode(i, j);
	if( originalCode >= 0)
        {
          /* if it is not seen */
          // if(randomAssignment.getColorCode(i, j) == unseen)
          if(matrix[i][j] == unseen)
          {
            /* get random color code */
            int randomCode = distribution.nextValue();
            // System.out.println("new random col " + randomCode + " " + i + " " +  j);
            /* color the cell and mark it as seen */
            // randomAssignment.setColorCode(i, j, randomCode);
            /* propagate the color to unseen connected neighbours */
            colorConnectedNeighbours(original,
				     i,
				     j,
				     windowRadius,
				     randomCode);
          }
        }
        else
        {
          // randomAssignment.setColorCode(i, j, matrix[i][j]);
	  matrix[i][j] = originalCode;
        }
      }
    }
  }
}











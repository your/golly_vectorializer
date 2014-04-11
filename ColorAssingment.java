public class ColorAssingment
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

  public ColorAssingment(int height,
                         int width
			 // ,
                         // ColorPalette colors
    )
  {
    initMatrix(height, width);
    // palette = colors;
  }
  
  public ColorAssingment(GollyRleConfiguration config
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
  public ColorAssingment newRandomColorAssignment(CategoricalDistribution distribution)
  {
    ColorAssingment randomAssignment = new ColorAssingment(matrixHeight, matrixWidth);

    int code = -1;
    for(int i = 0; i < matrixHeight; ++i)
    {
      for(int j = 0; j < matrixWidth; ++j)
      {
        /* cell is active */
        if(matrix[i][j] >= 0)
        {
          /* get a random state */
          code = distribution.nextValue();
        }
        else
        {
          code = matrix[i][j];
        }
      
        randomAssignment.setColorCode(i, j, code);
      }
    }
    
    return randomAssignment;
  }
  
}











public class ColorPalette implements java.io.Serializable
{
  int length;
  int maxLength;
  /* colors are stored as an array of ints */
  int[] colors;

  private static final int EMPTY_COLOR = Integer.MIN_VALUE;
  
  /* random generator */
  CategoricalDistribution distribution;
  
  /* ctors */
  public ColorPalette(int numColors)
  {
    maxLength = numColors;
    initColors(length);
    distribution = new CategoricalDistribution(numColors);
  }

  public ColorPalette(int numColors,
		      CategoricalDistribution probabilityDistribution)
  {
    maxLength = numColors;
    initColors(length);
    distribution = probabilityDistribution;
  }

  private void initColors(int length)
  {
    colors = new int [maxLength];

    /* -1 represents no color */
    for(int i = 0; i < maxLength; ++i)
    {
      colors[i] = EMPTY_COLOR;
    }

    length = 0;
  }

  public void setColor(int index, int color)
  {

    if(index > maxLength - 1)
      index = maxLength - 1; //def write @ last positionr
    
    colors[index] = color; //FIXED: index always in boundaries
    
    if (index == length) {
      length++; // FIXED: increment currently set colors of palette
      System.out.println("Aggiunti finora colori: " + length);
    } else if (index >= length && index < maxLength) {
      length = index + 1;
    }
  }

  /* DEPRECATED use setColor instead */
  // public boolean addColor(int color)
  // {
  //   boolean added = false;
  //   if(length < maxLength)
  //   {
  //     colors[length] = color;
  //     length++;
  //     added = true;
  //   }
  //   return added;
  // }

  public int getColor(int index)
  {
    if (index >= maxLength)
      index = maxLength - 1; //def read @ last position
    
    int color = colors[index]; //FIXED
    /* if the chosen index leads to a non color, try the last one */
    if(color == EMPTY_COLOR)
    {
      /* if zero colors are present, raise exception */
      color = colors[length - 1];
    }
    return color;
  }

  public void setColorProbability(int index, double prob)
  {
    distribution.setOutcomeProbability(index, prob);
  }

  public void setColorProbability(double[] dist)
  {
    distribution.setOutcomeProbabilities(dist);
  }

  public double getColorProbability(int index)
  {
    return distribution.getOutcomeProbability(index);
  }

  public int getRandomColor()
  {
    /* generate a random value between */
    int randomIndex = distribution.nextValue();
     
    return colors[randomIndex];
  }
  
  /* default color is the first one */
  public int getDefaultColor()
  {
    return colors[0];
  }

  public void setDefaultColor(int color)
  {
    colors[0] = color;
  }

  public int getPaletteLength()
  {
    return length;
  }
}


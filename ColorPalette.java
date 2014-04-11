public class ColorPalette
{
  int length;
  int maxLength;
  /* colors are stored as an array of ints */
  int[] colors;
  
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
      colors[i] = -1;
    }

    length = 0;
  }

  public void setColor(int index, int color)
  {
    if (index < maxLength) {
      if(colors[index] == -1)
	length++;
    } else
      index = maxLength - 1; //def write @ last position
    
    colors[index] = color; //FIXED: index always in boundaries
  }

  /* DEPRECATED use setColor instead */
  public boolean addColor(int color)
  {
    boolean added = false;
    if(length < maxLength)
    {
      colors[length] = color;
      length++;
      added = true;
    }
    return added;
  }

  public int getColor(int index)
  {
    if (index >= maxLength)
      index = maxLength - 1; //def read @ last position
    
    int color = colors[index]; //FIXED
    /* if the chosen index leads to a non color, try the last one */
    if(color == -1)
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
}


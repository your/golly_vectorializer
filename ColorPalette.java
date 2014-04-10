import java.util.Random;

public class ColorPalette
{
  int length;
  int maxLength;
  /* colors are stored as an array of ints */
  int[] colors;
  /* storing also the probability distribution to get one */
  double[] distribution;
  double[] cumulativeDistribution;
  /* random generator */
  Random randomGenerator = new Random();
  
  /* ctors */
  public ColorPalette(int numColors)
  {
    maxLength = numColors;
    initColors(length);
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
    
    distribution = new double [maxLength];

    /* making the distribution uniform */
    for(int i = 0; i < length; ++i)
    {
      distribution[i] = 1.0 / length;
    }

    cumulativeDistribution = new double [maxLength];
    computeCumulativeDistribution();
  }

  /* normalizing the values to be in [0, 1] and to sum to 1 */
  private void normalizeDistribution()
  {
    double sum = 0;
    
    for(int i = 0; i < length; ++i)
    {
      sum += distribution[i];
    }
    
    for(int i = 0; i < length; ++i)
    {
      distribution[i] /= sum;
    }
  }

  private void computeCumulativeDistribution()
  {
    double sum = 0;
    for(int i = 0; i < length; ++i)
    {
      sum += distribution[i];
      cumulativeDistribution[i] = sum;
    }
  }

  public void setColor(int index, int color)
  {
    if(colors[index] == -1)
    {
      length++;
    }
    
    colors[index] = color; //FIXME: oob write ¡!
  }

  public boolean addColor(int color)
  {
    boolean added = false;
    if(length < maxLength)
    {
      colors[length] = color;
      length++;
      normalizeDistribution();
      computeCumulativeDistribution();
      added = true;
    }
    return added;
  }

  public int getColor(int index)
  {
    int color = colors[index]; //FIXME: oob read ¡!
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
    distribution[index] = prob;
    /* getting a valid probability distribution */
    normalizeDistribution();
    computeCumulativeDistribution();
  }

  public void setColorProbability(double[] dist)
  {
    distribution = dist;
    normalizeDistribution();
    computeCumulativeDistribution();
  }

  public double getColorProbability(int index)
  {
    return distribution[index];
  }

  public int getRandomColor()
  {
    /* generate a random value between */
    double randomUnif = randomGenerator.nextDouble();
    int randomColor = -1;
    for(int i = 0; i < length && randomColor == - 1; ++i)
    {
      if(randomUnif < cumulativeDistribution[i])
      {
        randomColor = colors[i];
      }
    }
     
    return randomColor;
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


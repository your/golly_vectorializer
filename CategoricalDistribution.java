import java.util.Random;

public class CategoricalDistribution
{
  /* the number of possible outcomes */
  int outcomes;
  /* storing also the probability distribution and the cumilative one
     as array of probabilities */
  double[] distribution;
  double[] cumulativeDistribution;

  Random randomGenerator = new Random(); //maybe we can add a seed


  /*** ctors ***/

  /* values > 0 */
  public CategoricalDistribution(int values)
  {
    outcomes = values;
    /* initing as a uniform distribution */
    distribution = new double [values];
    initUniformDistribution(distribution);

    cumulativeDistribution = new double [values];
    initCumulativeDistribution(distribution,
			       cumulativeDistribution);
  }

  public CategoricalDistribution(int values, double[] probabilities)
  {
    outcomes = values;
    distribution = probabilities; /* here a copy ctor should be wiser */
    normalizeDistribution(distribution);
    cumulativeDistribution = new double [values];
    initCumulativeDistribution(distribution,
                               cumulativeDistribution);
  }

  /*** initing ***/
  private void initUniformDistribution(double [] probabilities)
  {
    int values = probabilities.length;
    double equalProbability = 1.0 / values;
    /* making the distribution uniform */
    for(int i = 0; i < values; ++i)
    {
      probabilities[i] = equalProbability;
    }
  }

  /* normalizing the values to be in [0, 1] and to sum to 1 */
  private void normalizeDistribution(double[] probabilities)
  {
    int values = probabilities.length;
    double sum = 0;
    
    for(int i = 0; i < values; ++i)
    {
      sum += probabilities[i];
    }
    
    for(int i = 0; i < values; ++i)
    {
      probabilities[i] /= sum;
    }
  }

  private void initCumulativeDistribution(double[] probabilities,
					  double[] cumulativeProbabilities)
  {
    int values = probabilities.length;
    double sum = 0;
    for(int i = 0; i < values; ++i)
    {
      sum += probabilities[i];
      cumulativeProbabilities[i] = sum;
    }
  }

  /*** getters and setters ***/
  public void setOutcomeProbability(int index, double prob)
  {
    distribution[index] = prob;
    /* getting a valid probability distribution */
    normalizeDistribution(distribution);
    initCumulativeDistribution(distribution, cumulativeDistribution);
  }

  public void setOutcomeProbabilities(double[] dist)
  {
    distribution = dist;
    normalizeDistribution(distribution);
    initCumulativeDistribution(distribution, cumulativeDistribution);
  }

  public double getOutcomeProbability(int index)
  {
    return distribution[index];
  }
  
  /* random value generation */
  public int nextValue()
  {
    double randomUnif = randomGenerator.nextDouble();
    int randomOutcome = -1;
    for(int i = 0; i < outcomes && randomOutcome == - 1; ++i)
    {
      if(randomUnif < cumulativeDistribution[i])
      {
        randomOutcome = i;
      }
    }
    return randomOutcome;
  }

}

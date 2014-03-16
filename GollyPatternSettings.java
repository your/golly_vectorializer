public class GollyPatternSettings
{
  /** Members */
  private int fillRActive;
  private int fillGActive;
  private int fillBActive;
  private int fillRInactive;
  private int fillGInactive;
  private int fillBInactive;
  private int strokeRActive;
  private int strokeGActive;
  private int strokeBActive;
  private int strokeRInactive;
  private int strokeGInactive;
  private int strokeBInactive;
  private int strokeWeightActive;
  private int strokeWeightInactive;
  private int cellWidth;
  private int cellHeight;

  /** Constructor */
  GollyPatternSettings(int backgroundR, int backgroundG, int backgroundB,
		       int cellWidth, int cellHeight)
  {
    fillRActive = invertColor(backgroundR);
    fillGActive = invertColor(backgroundG);
    fillBActive = invertColor(backgroundB);
    fillRInactive = backgroundR;
    fillGInactive = backgroundG;
    fillBInactive = backgroundB;
    strokeRActive = fillRActive;
    strokeGActive = fillGActive;
    strokeBActive = fillBActive;
    strokeRInactive = fillRInactive;
    strokeGInactive = fillGInactive;
    strokeBInactive = fillBInactive;
    strokeWeightActive = 1;
    strokeWeightInactive = 0;
    this.cellWidth = cellWidth;
    this.cellHeight = cellHeight;
  }

  
  /** Utilities:
   */
  
  private int invertColor(int val)
  {
    int inverted = (val - 255) == 0 ? 0 : (val - 255) * (-1);
    return inverted;
  }

  
  /** Getters:
   */

  public int getFillRActive()
  {
    return fillRActive;
  }

  public int getFillGActive()
  {
    return fillGActive;
  }

  public int getFillBActive()
  {
    return fillBActive;
  }

  public int getFillRInactive()
  {
    return fillRInactive;
  }

  public int getFillGInactive()
  {
    return fillGInactive;
  }

  public int getFillBInactive()
  {
    return fillBInactive;
  }

  public int getStrokeRActive()
  {
    return strokeRActive;
  }

  public int getStrokeGActive()
  {
    return strokeGActive;
  }

  public int getStrokeBActive()
  {
    return strokeBActive;
  }

  public int getStrokeRInactive()
  {
    return strokeRInactive;
  }

  public int getStrokeGInactive()
  {
    return strokeGInactive;
  }

  public int getStrokeBInactive()
  {
    return strokeBInactive;
  }

  public int getStrokeWeightActive()
  {
    return strokeWeightActive;
  }

  public int getStrokeWeightInactive()
  {
    return strokeWeightInactive;
  }

  public int getCellWidth()
  {
    return cellWidth;
  }

  public int getCellHeight()
  {
    return cellHeight;
  }
  
  /** Setters:
   */
  public void setFillRActive(int val)
  {
    fillRActive = val;
  }

  public void setFillGActive(int val)
  {
    fillGActive = val;
  }

  public void setFillBActive(int val)
  {
    fillBActive = val;
  }

  public void setFillRInactive(int val)
  {
    fillRInactive = val;
  }

  public void setFillGInactive(int val)
  {
    fillGInactive = val;
  }

  public void setFillBInactive(int val)
  {
    fillBInactive = val;
  }

  public void setStrokeRActive(int val)
  {
    strokeRActive = val;
  }

  public void setStrokeGActive(int val)
  {
    strokeGActive = val;
  }

  public void setStrokeBActive(int val)
  {
    strokeBActive = val;
  }

  public void setStrokeRInactive(int val)
  {
    strokeRInactive = val;
  }

  public void setStrokeGInactive(int val)
  {
    strokeGInactive = val;
  }

  public void setStrokeBInactive(int val)
  {
    strokeBInactive = val;
  }

  public void setStrokeWeightActive(int val)
  {
    strokeWeightActive = val;
  }

  public void setStrokeWeightInactive(int val)
  {
    strokeWeightInactive = val;
  }

  public void setCellWidth(int val)
  {
    cellWidth = val;
  }

  public void setCellHeight(int val)
  {
    cellHeight = val;
  }
  
}

public class GollyPatternSettings
{
  /** Members */
  private int fillRActive = 0;
  private int fillGActive = 0;
  private int fillBActive = 0;
  private int fillRInactive = 255;
  private int fillGInactive = 255;
  private int fillBInactive = 255;
  private int strokeRActive = 100;
  private int strokeGActive = 100;
  private int strokeBActive = 100;
  private int strokeRInactive = 255;
  private int strokeGInactive = 255;
  private int strokeBInactive = 255;
  private int strokeWeightActive = 1;
  private int strokeWeightInactive = 0;
  private CellShape cellShape = CellShape.SQUARE;
  private String SVGPath = null;

  /** Constructor */
  GollyPatternSettings() {}
  
  /** Getters: */
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

  public CellShape getCellShape()
  {
    return cellShape;
  }

  public String getSVGPath()
  {
    return SVGPath;
  }
  
  /** Setters */
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

  public void setCellShape(CellShape cellShape)
  {
    this.cellShape = cellShape;
  }

  public void setSVGPath(String path)
  {
    SVGPath = path;
  }
}

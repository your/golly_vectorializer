public class GollyPatternSettings
{
  /* Members */
  private int fillRActive = 0;
  private int fillGActive = 0;
  private int fillBActive = 0;
  private int fillAActive = 255;
  private int fillRInactive = 255;
  private int fillGInactive = 255;
  private int fillBInactive = 255;
  private int fillAInactive = 255;
  private int strokeRActive = 100;
  private int strokeGActive = 100;
  private int strokeBActive = 100;
  private int strokeAActive = 255;
  private int strokeRInactive = 255;
  private int strokeGInactive = 255;
  private int strokeBInactive = 255;
  private int strokeAInactive = 255;
  private int strokeWeightActive = 1;
  private int strokeWeightInactive = 0;
  private float shapeWidth = 7;
  private float shapeHeight = 7;
  //private float scaleFactor = 1.0f;
  private boolean showGrid = true;
  private boolean keepCellRatio = true;
  private boolean keepShapeRatio = true;
  private boolean shapesLikeCells = false;
  private boolean isStrokeOnActive = false;
  private boolean isStrokeOnInactive = false;
  private boolean isFillOnActive = true;
  private boolean isFillOnInactive = false;
  private CellShape cellShape = CellShape.SQUARE;
  private String SVGPath = null;
  private SketchTransformer transformer;
  private String rleFilePath = null;

  /* Utilities */
  public void initTransformer(float xOffset, float yOffset,
			      float scaleFactor) {
    transformer = new SketchTransformer(xOffset, yOffset, scaleFactor);
  }
  
  /* Getters: */
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

  public int getFillAActive()
  {
    return fillAActive;
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

  public int getFillAInactive()
  {
    return fillAInactive;
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

  public int getStrokeAActive()
  {
    return strokeAActive;
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

  public int getStrokeAInactive()
  {
    return strokeAInactive;
  }

  public int getStrokeWeightActive()
  {
    return strokeWeightActive;
  }

  public int getStrokeWeightInactive()
  {
    return strokeWeightInactive;
  }

  public float getShapeWidth()
  {
    return shapeWidth;
  }

  public float getShapeHeight()
  {
    return shapeHeight;
  }

  public SketchTransformer getTransformer()
  {
    return transformer;
  }

  // public float getScaleFactor()
  // {
  //   return scaleFactor;
  // }

  public boolean getShowGrid()
  {
    return showGrid;
  }
  
  public boolean getKeepCellRatio()
  {
    return keepCellRatio;
  }

  public boolean getKeepShapeRatio()
  {
    return keepShapeRatio;
  }
  
  public boolean getShapesLikeCells()
  {
    return shapesLikeCells;
  }
  
  public boolean isStrokeOnActive()
  {
    return isStrokeOnActive;
  }

  public boolean isStrokeOnInactive()
  {
    return isStrokeOnInactive;
  }

  public boolean isFillOnActive()
  {
    return isFillOnActive;
  }

  public boolean isFillOnInactive()
  {
    return isFillOnInactive;
  }

  public CellShape getCellShape()
  {
    return cellShape;
  }

  public String getSVGPath()
  {
    return SVGPath;
  }
  
  public String getRleFilePath()
  {
    return rleFilePath;
  }
  
  /* Setters */
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

  public void setFillAActive(int val)
  {
    fillAActive = val;
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

  public void setFillAInactive(int val)
  {
    fillAInactive = val;
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
  
  public void setStrokeAActive(int val)
  {
    strokeAActive = val;
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

  public void setStrokeAInactive(int val)
  {
    strokeAInactive = val;
  }
  
  public void setStrokeWeightActive(int val)
  {
    strokeWeightActive = val;
  }

  public void setStrokeWeightInactive(int val)
  {
    strokeWeightInactive = val;
  }

  public void setShapeWidth(float val)
  {
    shapeWidth = val;
  }

  public void setShapeHeight(float val)
  {
    shapeHeight = val;
  }

  // public void setScaleFactor(float val)
  // {
  //   scaleFactor = val;
  // }
  
  public void setShowGrid(boolean flag)
  {
    showGrid = flag;
  }
  
  public void setKeepCellRatio(boolean flag)
  {
    keepCellRatio = flag;
  }

  public void setKeepShapeRatio(boolean flag)
  {
    keepShapeRatio = flag;
  }

  public void setShapesLikeCells(boolean flag)
  {
    shapesLikeCells = flag;
  }
  
  public void setIsStrokeOnActive(boolean flag)
  {
    isStrokeOnActive = flag;
  }

  public void setIsStrokeOnInactive(boolean flag)
  {
    isStrokeOnInactive = flag;
  }

  public void setIsFillOnActive(boolean flag)
  {
    isFillOnActive = flag;
  }

  public void setIsFillOnInactive(boolean flag)
  {
    isFillOnInactive = flag;
  }

  public void setCellShape(CellShape cellShape)
  {
    this.cellShape = cellShape;
  }

  public void setSVGPath(String path)
  {
    SVGPath = path;
  }
  
  public void setRleFilePath(String path)
  {
    rleFilePath = path;
  }
}

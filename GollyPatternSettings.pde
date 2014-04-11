public class GollyPatternSettings
{
  /* Members */
  private int fillRActive = 0;
  private int fillGActive = 0;
  private int fillBActive = 0;
  private int fillAActive = 255;
  private int fillRInactive = 100;
  private int fillGInactive = 100;
  private int fillBInactive = 100;
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
  // private int scaleFactor = 1;
  private float shapeWidthActive = 7;
  private float shapeWidthInactive = 5;
  private float shapeHeightActive = 7;
  private float shapeHeightInactive = 5;
  private float scaleFactor = 1.0f;
  private boolean showGrid = true;
  private boolean showInactives = false;
  private boolean keepCellRatio = true;
  private boolean keepShapeRatioActive = true;
  private boolean keepShapeRatioInactive = true;
  private boolean shapesLikeCellsActive = false;
  private boolean shapesLikeCellsInactive = false;
  private boolean isStrokeOnActive = false;
  private boolean isStrokeOnInactive = false;
  private boolean isFillOnActive = true;
  private boolean isFillOnInactive = true;
  private boolean workingOnActiveStates = true;
  private CellShape cellShape = CellShape.SQUARE;
  private String SVGPath = null;
  private SketchTransformer transformer;
  private String rleFilePath = null;
  private CategoricalDistribution distribution;
  private ColorPalette colorPalette;
  private ColorMode colorMode = ColorMode.NORMAL;
  private ColorAssingment currentColorAssignment = null;
  private ColorAssingment normalColorAssignment = null;
  private ColorAssingment randomColorAssignment = null;
  private ColorAssingment randomLocalColorAssignment = null;

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

  // public int getScaleFactor()
  // {
  //   return scaleFactor;
  // }

  public float getShapeWidthActive()
  {
    return shapeWidthActive;
  }

  public float getShapeWidthInactive()
  {
    return shapeWidthInactive;
  }
  
  public float getShapeHeightActive()
  {
    return shapeHeightActive;
  }

  public float getShapeHeightInactive()
  {
    return shapeHeightInactive;
  }

  public SketchTransformer getTransformer()
  {
    return transformer;
  }

  public float getScaleFactor()
  {
    return scaleFactor;
  }

  public boolean getShowGrid()
  {
    return showGrid;
  }

  public boolean getShowInactives()
  {
    return showInactives;
  }
  
  public boolean getKeepCellRatio()
  {
    return keepCellRatio;
  }

  public boolean getKeepShapeRatioActive()
  {
    return keepShapeRatioActive;
  }

  public boolean getKeepShapeRatioInactive()
  {
    return keepShapeRatioInactive;
  }
  
  public boolean getShapesLikeCellsActive()
  {
    return shapesLikeCellsActive;
  }

  public boolean getShapesLikeCellsInactive()
  {
    return shapesLikeCellsInactive;
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

  public boolean workingOnActiveStates()
  {
    return workingOnActiveStates;
  }

  public CellShape getCellShape()
  {
    return cellShape;
  }

  public ColorMode getColorMode()
  {
    return colorMode;
  }

  public ColorAssingment getCurrentColorAssingment()
  {
    return currentColorAssignment;
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

  // public void setScaleFactor(int val)
  // {
  //   scaleFactor = val;
  // }

  public void setShapeWidthActive(float val)
  {
    shapeWidthActive = val;
  }

  public void setShapeWidthInactive(float val)
  {
    shapeWidthInactive = val;
  }
  
  public void setShapeHeightActive(float val)
  {
    shapeHeightActive = val;
  }

  public void setShapeHeightInactive(float val)
  {
    shapeHeightInactive = val;
  }
  
  public void setScaleFactor(float val)
  {
    scaleFactor = val;
  }
  
  public void setShowGrid(boolean flag)
  {
    showGrid = flag;
  }

  public void setShowInactives(boolean flag)
  {
    showInactives = flag;
  }
  
  public void setKeepCellRatio(boolean flag)
  {
    keepCellRatio = flag;
  }

  public void setKeepShapeRatioActive(boolean flag)
  {
    keepShapeRatioActive = flag;
  }

  public void setKeepShapeRatioInactive(boolean flag)
  {
    keepShapeRatioInactive = flag;
  }
  
  public void setShapesLikeCellsActive(boolean flag)
  {
    shapesLikeCellsActive = flag;
  }

  public void setShapesLikeCellsInactive(boolean flag)
  {
    shapesLikeCellsInactive = flag;
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

  public void setWorkingOnActiveStates(boolean flag)
  {
    workingOnActiveStates = flag;
  }

  public void setCellShape(CellShape cellShape)
  {
    this.cellShape = cellShape;
  }

  /* TODO check for nullness of assignment */
  public void setColorMode(ColorMode mode)
  {
    colorMode = mode;
    /* updating the color assignment */
    switch(mode)
    {
    case NORMAL:
      currentColorAssignment = normalColorAssignment;
      break;

    case RANDOM:
      if(randomColorAssignment == null)
      {
        randomColorAssignment =
          currentColorAssignment.newRandomColorAssignment(distribution);
      }
      currentColorAssignment = randomColorAssignment;
      break;

    case RANDOM_LOCAL:
      currentColorAssignment = randomLocalColorAssignment;
      break;

    default:
      currentColorAssignment = normalColorAssignment;
      break;
    }
  }

  // public void setColorPalette(ColorPalette palette)
  // {
  //   colorPalette = palette;
  // }

  /* color management, hiding the palette and the assignment */
  public void initColors(int numColors, GollyRleConfiguration config)
  {
    /* assuming a uniform distribution at start
       creating a palette */
    distribution = new CategoricalDistribution(numColors);
    colorPalette = new ColorPalette(numColors, distribution);

    /* creating a new color assignment */
    normalColorAssignment = new ColorAssingment(config);
    /* setting it as the current one */
    currentColorAssignment = normalColorAssignment;
  }

  public void setColorProbability(int index, double prob)
  {
    colorPalette.setColorProbability(index, prob);
  }

  public void setColor(int index, int code)
  {
    colorPalette.setColor(index, code);
  }

  public int getColor(int index)
  {
    return colorPalette.getColor(index);
  }

  public int getColor(int i, int j)
  {
    int code = currentColorAssignment.getColorCode(i, j);
    int cellColor = -1; /* TODO: set the inactive color */
    if(code >= 0)
    {
      cellColor = colorPalette.getColor(code);
    }

    return cellColor;
  }
    
  /* file utils */  
  public void setSVGPath(String path)
  {
    SVGPath = path;
  }
  
  public void setRleFilePath(String path)
  {
    rleFilePath = path;
  }
}

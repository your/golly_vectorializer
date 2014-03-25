public class SketchTransformer
{
  private float xOffset;
  private float yOffset;
  private float scaleFactor;
  
  private float mouseXPosition;
  private float mouseYPosition;
  
  private PGraphics graphicContext;
  private boolean isAnimating;
  private boolean dragging = false;

  public SketchTransformer(float xOffset, float yOffset, float scaleFactor, PGraphics pg)
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.scaleFactor = scaleFactor;
    this.graphicContext = pg;
    isAnimating = false;
  }

  public SketchTransformer(float xOffset, float yOffset, float scaleFactor)
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.scaleFactor = scaleFactor;
    this.graphicContext = g;
    isAnimating = false;
  }
  
  public SketchTransformer()
  {
    this.xOffset = 0;
    this.yOffset = 0;
    this.scaleFactor = 0;
    this.graphicContext = g;
    isAnimating = false;
  }
  
  
  public void setXOffset(float offset)
  {
    this.xOffset = offset;
  }
  
  public float getXOffset()
  {
    return this.xOffset;
  }
  
  public void setYOffset(float offset)
  {
    this.yOffset = offset;
  }
  
  public float getYOffset()
  {
    return this.yOffset;
  }
  
  public void setScaleFactor(float factor)
  {
    this.scaleFactor = factor;
  }

  public float getScaleFactor()
  {
    return this.scaleFactor;
  }

  public void setGraphicContext(PGraphics pg)
  {
    this.graphicContext = pg;
  }

  public PGraphics getGraphicContext()
  {
    return this.graphicContext;
  }


  public PVector translateCoordinates(float x, float y)
  {
    PVector translatedPoint = new PVector((x - xOffset) / scaleFactor, (y - yOffset) / scaleFactor);
    return translatedPoint;
  }
  
  public void setTraslationOffsets(float xOffset, float yOffset)
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
  
  public void saveMousePosition(float mouseXPos, float mouseYPos)
  {
    this.mouseXPosition = mouseXPos;
    this.mouseYPosition = mouseYPos;
    dragging = true;
  }
  
  public void updateTranslationOffset(float mouseXPos, float mouseYPos)
  {
    if(dragging)
    {
      this.xOffset -= this.mouseXPosition - mouseXPos;
      this.yOffset -= this.mouseYPosition - mouseYPos;
    
      this.mouseXPosition = mouseXPos;
      this.mouseYPosition = mouseYPos;
    }
  }
  
  public void resetMousePosition()
  {
    dragging = false;
    /* maybe resetting the mouse position too would not be bad */
  }
  
  
  public void startDrawing(float additionalXOffset, float additionalYOffset, float additionalScaling)
  {
    graphicContext.pushMatrix();
    graphicContext.translate(xOffset + additionalXOffset, yOffset + additionalYOffset);
    graphicContext.scale(scaleFactor + additionalScaling);
  }
  
  public void startDrawing()
  {
    this.startDrawing(0, 0, 0);
  }
  
  public void endDrawing()
  {
    graphicContext.popMatrix();
  }
  
  public void centerSketch()
  {
    xOffset = yOffset = 0;
  }

  public void centerSketch(float drawAreaWidth, float voidDrawAreaWidth,
                           float drawAreaHeight, float voidDrawAreaHeight,
                           float patternWidth, float patternHeight)
  {
      xOffset = (drawAreaWidth - voidDrawAreaWidth)/2 - patternWidth/2;
      yOffset = (drawAreaHeight - voidDrawAreaHeight)/2 - patternHeight/2;
  }
  
  private void animateCentering()
  {
//    if (isAnimating)
//    {
//      xOffset *= deltaX;
//      println("X: " + traX + " Y: " + traY);
//      if (abs(traX - width/2) < thresholdFloat && abs(traY - height*3/4) < thresholdFloat)
//      {
//        println("stop animation");
//        isAnimating = false;
//        traX = width/2;
//        traY = height*3/4;
//      }
//    }
  }
}

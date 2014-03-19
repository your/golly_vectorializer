import java.io.*;
import java.util.*;
import controlP5.*;

/* Global variables */
GollyRleReader reader;
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;
SketchTransformer transformer;
Grid2D currentGrid;
ControlP5 cp5;
// ResizableColorPicker cp5e;
Group mainG, settG, lockG, winG;

/* Default window/drawing settings */
int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int cellDim = 10;
color bg = color(255);
color cp = color(10,20,10,200);
color cq = color(200,180,200,100);
boolean keepRatio = true;
boolean initControls = false;
boolean lockedGrid = false;

void manageControls(boolean lock)
{
  /* Locking/unlocking controls */
  // gridG
  setLock(cp5.getController("cellWidth"),lock);
  setLock(cp5.getController("cellHeight"),lock);
  setLock(cp5.getController("toggleKeepRatioCells"),lock);
  // settG
  setLock(cp5.getController("shapeWidth"),lock);
  setLock(cp5.getController("shapeHeight"),lock);
  setLock(cp5.getController("toggleKeepRatioShapes"),lock);
  setLock(cp5.getController("pickRFillActive"),lock);
  setLock(cp5.getController("pickGFillActive"),lock);
  setLock(cp5.getController("pickBFillActive"),lock);
  setLock(cp5.getController("pickAFillActive"),lock);
  setLock(cp5.getController("toggleFillActive"),lock);
  setLock(cp5.getController("pickRStrokeActive"),lock);
  setLock(cp5.getController("pickGStrokeActive"),lock);
  setLock(cp5.getController("pickBStrokeActive"),lock);
  setLock(cp5.getController("pickAStrokeActive"),lock);
  setLock(cp5.getController("toggleStrokeActive"),lock);
  if (!lock)
  {
    /* Colouring sliders if unlocked */
    cp5.getController("pickRFillActive").setColorBackground(color(200,20,40));
    cp5.getController("pickRStrokeActive").setColorBackground(color(200,20,40));
    cp5.getController("pickGFillActive").setColorBackground(color(20,200,40));
    cp5.getController("pickGStrokeActive").setColorBackground(color(20,200,40));
    cp5.getController("pickBFillActive").setColorBackground(color(40,20,200));
    cp5.getController("pickBStrokeActive").setColorBackground(color(40,20,200));
    cp5.getController("pickAFillActive").setColorBackground(color(100,100,100));
    cp5.getController("pickAStrokeActive").setColorBackground(color(100,100,100));
  }
}

void setup()
{
  /* Setting up main display settings */
  smooth();
  frameRate(30);
  
  size(x,y,P2D);

  transformer = new SketchTransformer((width-sizeCP5Group)/2, height/2, 1.0);
  
  background(bg);

  /* Global objects init */
  manager = new GollyHistoryManager();
  reader = new GollyRleReader();
  currentSettings = new GollyPatternSettings();
  currentGrid = new Grid2D();

  /* Building CP5 objects */
  cp5 = new ControlP5(this);
  // MAIN CONTROLS
  // MAIN GROUP AREA
  mainG = cp5.addGroup("mainControls")
    .setPosition(width-sizeCP5Group,0)
    .setSize(sizeCP5Group,height)
    //.setBackgroundColor(color(0,0,0,0))
    ;
  // GRID SUBGROUP AREA
  Group gridG = cp5.addGroup("gridControls")
    .setPosition(10,100)
    .setSize(180,95)
    //.setBackgroundColor(color(20,0,20,150))
    .setBackgroundColor(color(175,190,175,220))
    .setLabel("Impostazioni Griglia").setColorBackground(color(10,0,10,200))
    .moveTo(mainG)
    ;
  cp5.addTextlabel("resizeCells")
    .setPosition(2,10)
    .setText("DIMENSIONE CELLE")
    .moveTo(gridG)
    ;
  cp5.addSlider("cellWidth")
    .setLabel("L")
    .setPosition(2,25)
    .setSize(165,10)
    .setValue(currentGrid.getCellWidth())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addSlider("cellHeight")
    .setLabel("A")
    .setPosition(2,40)
    .setSize(165,10)
    .setValue(currentGrid.getCellHeight())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addToggle("toggleKeepRatioCells")
    .setLabel("Keep Ratio")
    .setPosition(5,60)
    .setSize(42,15)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
  // SETTINGS SUBGROUP AREA
  settG = cp5.addGroup("settControls")
    .setPosition(10,250)
    .setSize(180,350)
    .setBackgroundColor(color(175,190,175,220))
    //.setBackgroundColor(color(20,0,20,150))
    //.setBackgroundColor(color(0,0,0,220))
    .setLabel("Impostazioni Pattern").setColorBackground(color(10,0,10,200))
    .moveTo(mainG)
    ;
  // SHAPES AREA
  cp5.addTextlabel("resizeShapes")
    .setPosition(2,10)
    .setText("DIMENSIONE FORME")
    .moveTo(settG)
    ;
  cp5.addSlider("shapeWidth")
    .setLabel("L")
    .setPosition(2,25)
    .setSize(165,10)
    .setValue(currentSettings.getShapeWidth())
    .setRange(0,200)
    .moveTo(settG)
    ;
  cp5.addSlider("shapeHeight")
    .setLabel("A")
    .setPosition(2,40)
    .setSize(165,10)
    .setValue(currentSettings.getShapeHeight())
    .setRange(0,200)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleKeepRatioShapes")
    .setLabel("Keep Ratio")
    .setPosition(5,60)
    .setSize(42,15)
    .setValue(currentSettings.getKeepRatio())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  cp5.addTextlabel("pickerFillLabel")
    .setPosition(3,105)
    .setText("RIEMPIMENTO FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addSlider("pickRFillActive")
    .setLabel("R")
    .setPosition(3,120)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillRActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGFillActive")
    .setLabel("G")
    .setPosition(3,131)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillGActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBFillActive")
    .setLabel("B")
    .setPosition(3,142)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillBActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAFillActive")
    .setLabel("A")
    .setPosition(3,153)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillAActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleFillActive")
    .setLabel("Fill ON")
    .setPosition(125,165)
    .setSize(42,15)
    .setValue(currentSettings.isFillOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  cp5.addTextlabel("pickerStrokeLabel")
    .setPosition(3,205)
    .setText("CONTORNO FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addSlider("pickRStrokeActive")
    .setLabel("R")
    .setPosition(3,220)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeRActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGStrokeActive")
    .setLabel("G")
    .setPosition(3,231)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeGActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBStrokeActive")
    .setLabel("B")
    .setPosition(3,242)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeBActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAStrokeActive")
    .setLabel("A")
    .setPosition(3,253)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeAActive())
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleStrokeActive")
    .setLabel("Stroke ON")
    .setPosition(125,265)
    .setSize(42,15)
    .setValue(currentSettings.isStrokeOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  
  // cp5e = new ResizableColorPicker(cp5,"pickerFillActive");
  // cp5e.setPosition(2,120)
  //   .setColorValue(color(0))
  //   .moveTo(settG)
  //   ;
  // //cp5e.setItemSize(175,10)
  //   // ;
  // cp5e = new ResizableColorPicker(cp5,"pickerStrokeActive");
  // cp5e.setPosition(2,225)
  //   .setColorValue(0)
  //   .moveTo(settG)
  //   ;
  // cp5e.setItemSize(175,10)
  //   ;

  // LOCK GROUP
  lockG = cp5.addGroup("lockBox")
    .setSize(width,height)
    .setPosition(0,0)
    .setBackgroundColor(color(10,0,10,200))
    .hide()
    ;
  // LOAD RLE AREA
  cp5.addButton("loadRleConfig")
    .setLabel("Aggiungi File RLE di Golly")
    .setPosition(40,20)
    .setSize(110,19)
    .setColorBackground(cp)
    .moveTo(mainG)
    ;
  // HISTORY AREA
  cp5.addButton("rewindConfigHistory")
    .setLabel("< prev")
    .setPosition((width-sizeCP5Group)/2-20,height-50)
    .setColorBackground(cq)
    .setSize(35,25)
    ;
  cp5.addButton("forwardConfigHistory")
    .setLabel("next >")
    .setPosition((width-sizeCP5Group)/2+20,height-50)
    .setColorBackground(cq)
    .setSize(35,25)
    ;
  
  /* History starting locks */
  setLock(mainG.getController("rewindConfigHistory"),true);
  setLock(mainG.getController("forwardConfigHistory"),true);

  // MESSAGE BOX AREA
  winG =
    cp5.addGroup("messageBox")
    .setPosition(width/2-150,height/2-150)
    .setSize(300,300)
    .setBackgroundHeight(120)
    .setBackgroundColor(color(0,100))
    .moveTo(lockG)
    //.hideBar()
    ;  
  cp5.addButton("buttonOk")
    .setPosition(80,80)
    .setSize(18,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Ok")
    ;
  
  /* Message box is shown only upon request */
  winG.hide();

  /* Lock controls @startup */
  manageControls(true);
}

void showPopup() {
  lockG.show();
  cp5.addTextlabel("messageBoxLabel",
                   "Giovani, qui accettiamo solo file in formato RLE di Golly!\n\n"+
                   "(In alternativa provate a dropparli o copia-incollarli)",30,30)
    .moveTo(winG)
    ;
  winG.show();
}

/* CP5 class extends */
// class ResizableColorPicker extends ColorPicker
// {
//   ResizableColorPicker(ControlP5 cp5, String theName)
//   {
//     super(cp5, cp5.getTab("default"), theName, 0, 0, 100, 10);
//   }
//   void setItemSize(int w, int h)
//   {
//     sliderRed.setSize(w, h);
//     sliderGreen.setSize(w, h);
//     sliderBlue.setSize(w, h);
//     sliderAlpha.setSize(w, h);
   
//     // you gotta move the sliders as well or they will overlap
//     // sliderGreen.setPosition(PVector.add(sliderGreen.getPosition(), new PVector(0, h-10)));
//     // sliderBlue.setPosition(PVector.add(sliderBlue.getPosition(), new PVector(0, 2*(h-10))));
//     // sliderAlpha.setPosition(PVector.add(sliderAlpha.getPosition(), new PVector(0, 3*(h-10))));
//   }
// }

void setLock(Controller theController, boolean theValue)
{
  theController.setLock(theValue);
  if(theValue)
  {
    theController.setColorBackground(cq);
  }
  else
  {
    theController.setColorBackground(cp);
  }
}
  
/* CP5 objects callbacks */
void cellWidth(float val)
{
  currentGrid.setCellWidth(val);
  if (keepRatio)
    currentGrid.setCellHeight(val);
    
}
void cellHeight(float val)
{
  currentGrid.setCellHeight(val);
  if (keepRatio)
    currentGrid.setCellWidth(val);
}
void shapeWidth(float val)
{
  currentSettings.setShapeWidth(val);
  if (currentSettings.getKeepRatio())
    currentSettings.setShapeHeight(val);
  manager.updateSettingsHistory(currentSettings);
}
void shapeHeight(float val)
{
  currentSettings.setShapeHeight(val);
  if (currentSettings.getKeepRatio())
    currentSettings.setShapeWidth(val);
  manager.updateSettingsHistory(currentSettings);
}

void forwardConfigHistory(int status)
{
  manager.forwardHistory();
  checkConfigHistory();
}
void rewindConfigHistory(int status)
{
  manager.rewindHistory();
  checkConfigHistory();
}
void loadRleConfig(int status)
{
  selectInput("Selezionare un file RLE di Golly:", "fileSelected");
}
void toggleKeepRatioCells(boolean flag)
{
   if (flag == true)
     keepRatio = true;
   else
     keepRatio = false;
}
void toggleKeepRatioShapes(boolean flag)
{
  currentSettings.setKeepRatio(flag);
  manager.updateSettingsHistory(currentSettings);
}

// void toggleNoStroke(boolean flag)
// {
//   if (g.getStyle().stroke)
//     g.noStroke();
//   else
//     g.stroke(g.getStyle().strokeColor); 
// }
// void toggleNoFill(boolean flag)
// {
//   if (g.getStyle().fill)
//     g.noFill();
//   else
//     g.fill(g.getStyle().fillColor); 
// }
void toggleStrokeActive(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleStrokeActive").setLabel("Stroke " + status);
  currentSettings.setIsStrokeOnActive(flag);
  manager.updateSettingsHistory(currentSettings);
}
void toggleFillActive(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleFillActive").setLabel("Fill " + status);
  currentSettings.setIsFillOnActive(flag);
  manager.updateSettingsHistory(currentSettings);
}
void buttonOk(int theValue) {
  winG.getController("messageBoxLabel").remove();
  winG.hide();
  lockG.hide();
}
void pickRFillActive(int val)
{
  currentSettings.setFillRActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickGFillActive(int val)
{
  currentSettings.setFillGActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickBFillActive(int val)
{
  currentSettings.setFillBActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickAFillActive(int val)
{
  currentSettings.setFillAActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickRStrokeActive(int val)
{
  currentSettings.setStrokeRActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickGStrokeActive(int val)
{
  currentSettings.setStrokeGActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickBStrokeActive(int val)
{
  currentSettings.setStrokeBActive(val);
  manager.updateSettingsHistory(currentSettings);
}
void pickAStrokeActive(int val)
{
  currentSettings.setStrokeAActive(val);
  manager.updateSettingsHistory(currentSettings);
}
// void pickerFillActive(int val)
// {
//   currentSettings.setFillRActive((int)red(val));
//   currentSettings.setFillGActive((int)green(val));
//   currentSettings.setFillBActive((int)blue(val));
//   currentSettings.setFillAActive((int)alpha(val));

//   /* Adding settings to history */
//   manager.updateSettingsHistory(currentSettings);
// }
// void pickerStrokeActive(int val)
// {
//   currentSettings.setStrokeRActive((int)red(val));
//   currentSettings.setStrokeGActive((int)green(val));
//   currentSettings.setStrokeBActive((int)blue(val));
//   currentSettings.setStrokeAActive((int)alpha(val));

//   /* Adding settings to history */
//   manager.updateSettingsHistory(currentSettings);
// }

/* Processing file selection callback */
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String gollyFilePath = selection.getAbsolutePath();
    println("User selected " + gollyFilePath);
    loadGollyFile(gollyFilePath);
   }
}

void generateGridFrom(GollyRleConfiguration config)
{
  PVector origin = new PVector();
  
  int cols = config.getMatrixWidth();
  int rows = config.getMatrixHeight();

  float cellWidth = cellDim;
  float cellHeight = cellDim;

  // /* Centering grid */
  // origin.x = (x-sizeCP5Group)/2 - cols*cellWidth/2;
  // origin.y = (y-sizeCP5Group)/2 - rows*cellHeight/2;

  Grid2D genGrid = new Grid2D(origin, cols, rows, cellWidth, cellHeight); 
  /* Adding grid to history */
  manager.addGrid(genGrid);
  
}

/* Drawing methods */
void drawGollyPattern(PGraphics ctx,
                      Grid2D grid,
                      GollyRleConfiguration config,
                      GollyPatternSettings settings)
{  
  /* Setting up shape */
  PShape cellShape = generateShape(settings.getShapeWidth(),
                                   settings.getShapeHeight(),
                                   settings.getCellShape(),
                                   settings.getSVGPath());

  color colorFillActive = color(settings.getFillRActive(),
                                settings.getFillGActive(),
                                settings.getFillBActive());
  
  color colorStrokeActive = color(settings.getStrokeRActive(),
                                  settings.getStrokeGActive(),
                                  settings.getStrokeBActive());
  
  for (int i = 0; i < grid.getRows(); i++)
  {
    for (int j = 0; j < grid.getColumns(); j++)
    {
      int currentState = config.getCellState(i,j);
      if (currentState == 1) // draw shapes only into active cells
      {
        // Setting PShape fill&stroke up
        if (settings.isFillOnActive())
          cellShape.setFill(colorFillActive);
        else
          cellShape.setFill(false);
        if (settings.isStrokeOnActive())
          cellShape.setStroke(colorStrokeActive);
        else
          cellShape.setStroke(false);

        // Drawind shapes
        PVector currentPoint = grid.getPoint(i,j);
        ctx.shape(cellShape, currentPoint.x, currentPoint.y);
      }
    }
  }
  
}

PShape generateShape(float w, float h,
                     CellShape shapeType, String SVGPath)
{
  PShape patternShape = createShape();
  switch(shapeType)
  {
  case SQUARE: // to be correct, this is a generic rect
    patternShape.beginShape();
    patternShape.vertex(0,0);
    patternShape.vertex(0,w);
    patternShape.vertex(w,h);
    patternShape.vertex(h,0);
    patternShape.vertex(0,0);
    patternShape.endShape();
    // patternShape = createShape(RECT,0,0,w,h);
    break;
  case CIRCLE:
    patternShape = createShape(ELLIPSE,0,0,w,h);
    // circles are not so easy to draw using curveVertex()..
    // ..but we can build very complex shapes in the future
    break;
  case CUSTOM:
    patternShape = loadShape(SVGPath); // todo: resize svg
    break;
  }
  return patternShape;
}

void checkConfigHistory()
{
  /* Config history handling */
  if (manager.hasPrevConfig())
    setLock(mainG.getController("rewindConfigHistory"),false);
  else
    setLock(mainG.getController("rewindConfigHistory"),true);
  if (manager.hasNextConfig())
    setLock(mainG.getController("forwardConfigHistory"),false);
  else
    setLock(mainG.getController("forwardConfigHistory"),true);
}

void draw()
{
  transformer.startDrawing();
  /* Refreshing bg */
  background(bg);
  /* Getting current history snapshot */
  currentConfig = manager.getCurrentConfiguration();
  currentGrid = manager.getCurrentGrid();
  currentSettings = manager.getCurrentSettings();
  if (currentConfig != null && currentGrid != null) // cannot ever be null if loadGollyFile() has been called
  {
    drawGollyPattern(g, currentGrid, currentConfig, currentSettings);
  }

  //drawGuiElements
  //
  transformer.endDrawing();
}

/* Golly file loader */
void loadGollyFile(String gollyFile)
{
  /* Trying to get configuration from parser */
  try
  {
    GollyRleConfiguration newConfig = reader.parseFile(gollyFile);
    /* Adding it to history */
    manager.addConfiguration(newConfig);
    /* Generating grid from it (then adding it to history) */
    generateGridFrom(newConfig);
    /* Can we enable nextConfig button? */
    checkConfigHistory();
    /* Adding default settings to history */
    manager.addSettings(new GollyPatternSettings()); // start pattern with defaults
    /* Init controls */
    manageControls(false);
  }
  catch (RuntimeException e)
  {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
    showPopup();
  }
  catch (IOException e)
  {
    System.err.println("ERROR: " + e.getMessage());
  }
}

void center(int value)
{
  transformer.setTraslationOffsets(width/2, height/2);
}

void mousePressed()
{
  if (mouseX < x - sizeCP5Group) // avoid sliders conflict
    transformer.saveMousePosition(mouseX, mouseY);
}

void mouseReleased()
{
}

void mouseDragged()
{
  if (mouseX < x - sizeCP5Group) // avoid sliders conflict
    transformer.updateTranslationOffset(mouseX, mouseY);
}

void keyPressed()
{
}

void keyReleased()
{
}

/* Mouse events */
// void mousePressed()
// {
//   if (currentGrid != null)
//   {
//     if(overGrid)
//     { 
//       lockedGrid = true; 
//       //fill(255, 255, 255);
//     }
//     else
//     {
//       lockedGrid = false;
//     }
//     xOffset = mouseX - currentGrid.getX0();
//     yOffset = mouseY - currentGrid.getY0();
//   }
// }
// void mouseDragged()
// {
//   if (currentGrid != null)
//   {
//     if(lockedGrid)
//     {
//       currentGrid.setX0(mouseX-xOffset); 
//       currentGrid.setY0(mouseY-yOffset); 
//     }
//   }
// }
// void mouseReleased()
// {
//   if (currentGrid != null)
//   {
//     lockedGrid = false;
//   }
// }

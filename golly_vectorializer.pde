import java.io.*;
import java.util.*;
import controlP5.*;
import processing.pdf.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.KeyEvent;

/* Global variables */
GollyRleReader reader;
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;
SketchTransformer transformer;
Grid2D currentGrid;
ControlP5 cp5;
// ResizableColorPicker cp5e;
Group mainG, gridG, lockG, winG;
String gollyFilePath;
String pastedMessage;
boolean[] keys = new boolean[526];

/* Default window/drawing settings */
int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int cellDim = 10;
float scaleUnit = 0.05;
float pdfBorder = 5.0;
color bg = color(255);
color cp = color(10,20,10,200);
color cq = color(200,180,200,100);
boolean keepRatio = true;
boolean initControls = false;
boolean lockedGrid = false;
boolean initedDrawing = false;

void manageControls(boolean lock)
{
  /* Locking/unlocking controls */
  // mainG
  setLock(cp5.getController("exportToPDF"),lock);
  // gridG
  setLock(cp5.getController("cellWidth"),lock);
  setLock(cp5.getController("cellHeight"),lock);
  setLock(cp5.getController("toggleKeepRatioCells"),lock);
  setLock(cp5.getController("zoomIn"),lock);
  setLock(cp5.getController("zoomOut"),lock);
  setLock(cp5.getController("center"),lock);
  // settG
  setLock(cp5.getController("rowsNum"),true); // temp disabled
  setLock(cp5.getController("colsNum"),true); // temp disabled
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
  
  size(x,y);

  // /* setting up transformer */
  // transformer = new SketchTransformer((width-sizeCP5Group)/2, height/2, 1.0);
  
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
  gridG = cp5.addGroup("gridControls")
    .setPosition(10,130)
    .setSize(180,155)
    //.setBackgroundColor(color(20,0,20,150))
    .setBackgroundColor(color(175,190,175,220))
    .setLabel("Impostazioni Griglia").setColorBackground(color(10,0,10,200))
    .moveTo(mainG)
    ;
  cp5.addTextlabel("resizeGrid")
    .setPosition(2,10)
    .setText("DIMENSIONE GRIGLIA (beta disabled)")
    .moveTo(gridG)
    ;
  cp5.addSlider("rowsNum")
    .setLabel("ROWS")
    .setPosition(2,25)
    .setSize(150,10)
    .setValue(currentGrid.getRows())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addSlider("colsNum")
    .setLabel("COLS")
    .setPosition(2,40)
    .setSize(150,10)
    .setValue(currentGrid.getColumns())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addTextlabel("resizeCells")
    .setPosition(2,60)
    .setText("DIMENSIONE CELLE")
    .moveTo(gridG)
    ;
  cp5.addSlider("cellWidth")
    .setLabel("L")
    .setPosition(2,75)
    .setSize(165,10)
    .setValue(currentGrid.getCellWidth())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addSlider("cellHeight")
    .setLabel("A")
    .setPosition(2,90)
    .setSize(165,10)
    .setValue(currentGrid.getCellHeight())
    .setRange(0,200)
    .moveTo(gridG)
    ;
  cp5.addToggle("toggleKeepRatioCells")
    .setLabel("Keep Ratio")
    .setPosition(5,110)
    .setSize(42,15)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
  cp5.addButton("zoomIn")
    .setLabel("Zoom +")
    .setPosition(70,110)
    .setSize(35,15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addButton("zoomOut")
    .setLabel("Zoom -")
    .setPosition(110,110)
    .setSize(35,15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addTextlabel("zoomPercentage")
    .setText("100%")
    .setPosition(150,113)
    .setSize(35,15)
    .moveTo(gridG)
    ;
  cp5.addButton("center")
    .setLabel("Centrami!").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(70,130)
    .setSize(75,15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  // SETTINGS SUBGROUP AREA
  Group settG = cp5.addGroup("settControls")
    .setPosition(10,300)
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
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGFillActive")
    .setLabel("G")
    .setPosition(3,131)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillGActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBFillActive")
    .setLabel("B")
    .setPosition(3,142)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillBActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAFillActive")
    .setLabel("A")
    .setPosition(3,153)
    .setSize(165,10)
    .setColorValue(currentSettings.getFillAActive())
    .setColorForeground(color(255, 255, 255))
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
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGStrokeActive")
    .setLabel("G")
    .setPosition(3,231)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeGActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBStrokeActive")
    .setLabel("B")
    .setPosition(3,242)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeBActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0,255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAStrokeActive")
    .setLabel("A")
    .setPosition(3,253)
    .setSize(165,10)
    .setColorValue(currentSettings.getStrokeAActive())
    .setColorForeground(color(255, 255, 255))
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
  cp5.addButton("exportToPDF")
    .setLabel("Esporta in PDF")
    .setPosition(40,43)
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
    .hideBar()
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

void showPopup(String message)
{
  lockG.show();
  cp5.addTextlabel("messageBoxLabel",message,30,30)
    .moveTo(winG)
    ;
  winG.show();
}

boolean fileExists(String filename) {

  File file = new File(filename);

  if(!file.exists())
    return false;
   
  return true;
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
void rowsNum(int val)
{
  currentGrid.setRows(val);
}
void colsNum(int val)
{
  currentGrid.setColumns(val);
}
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
}
void shapeHeight(float val)
{
  currentSettings.setShapeHeight(val);
  if (currentSettings.getKeepRatio())
    currentSettings.setShapeWidth(val);
}

void forwardConfigHistory(int status)
{
  manager.forwardHistory();
  updateHistory();
}
void rewindConfigHistory(int status)
{
  manager.rewindHistory();
  updateHistory();
}
void updateHistory()
{
  currentGrid = manager.getCurrentGrid();
  currentConfig = manager.getCurrentConfiguration();
  currentSettings = manager.getCurrentSettings();
  checkConfigHistory();
}
void loadRleConfig(int status)
{
  selectInput("Selezionare un file RLE di Golly:", "fileSelected");
}
void exportToPDF(int status)
{
  selectOutput("Selezionare destinazione PDF:", "pdfSelected");
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
}
void toggleFillActive(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleFillActive").setLabel("Fill " + status);
  currentSettings.setIsFillOnActive(flag);
}
void buttonOk(int theValue) {
  winG.getController("messageBoxLabel").remove();
  winG.hide();
  lockG.hide();
}
void pickRFillActive(int val)
{
  currentSettings.setFillRActive(val);
}
void pickGFillActive(int val)
{
  currentSettings.setFillGActive(val);
}
void pickBFillActive(int val)
{
  currentSettings.setFillBActive(val);
}
void pickAFillActive(int val)
{
  currentSettings.setFillAActive(val);
}
void pickRStrokeActive(int val)
{
  currentSettings.setStrokeRActive(val);
}
void pickGStrokeActive(int val)
{
  currentSettings.setStrokeGActive(val);
}
void pickBStrokeActive(int val)
{
  currentSettings.setStrokeBActive(val);
}
void pickAStrokeActive(int val)
{
  currentSettings.setStrokeAActive(val);
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

void updateZoomPercentage()
{
  float scaleFactor = transformer.getScaleFactor();
  int percentage = ceil(100 * scaleFactor);
  cp5.remove("zoomPercentage");
  cp5.addTextlabel("zoomPercentage")
    .setText(percentage+"%")
    .setPosition(150,113)
    .setSize(35,15)
    .moveTo(gridG)
    ;
}

void zoomIn(int status)
{
  float scaleFactor = transformer.getScaleFactor();
  scaleFactor += scaleUnit;
  transformer.setScaleFactor(scaleFactor);
  centerSketch();
  updateZoomPercentage();
}
void zoomOut(int status)
{
  float scaleFactor = transformer.getScaleFactor();
  if (scaleFactor > scaleUnit) 
    scaleFactor -= scaleUnit;
  transformer.setScaleFactor(scaleFactor);
  centerSketch();
  updateZoomPercentage();
}

/* Processing file selection callback */
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    gollyFilePath = selection.getAbsolutePath();
    println("User selected " + gollyFilePath);
    loadGollyRle();
   }
}
void pdfSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String pdfPath = selection.getAbsolutePath();
    println("User selected " + pdfPath);
    exportNow(pdfPath);
  }
}

/* Drawing methods */
// void drawGollyPattern(PGraphics ctx,
//                       Grid2D grid,
//                       GollyRleConfiguration config,
//                       GollyPatternSettings settings)
// {  
//   /* Setting up shape */
//   PShape cellShape = generateShape(settings.getShapeWidth(),
//                                    settings.getShapeHeight(),
//                                    settings.getCellShape(),
//                                    settings.getSVGPath());

//   color colorFillActive = color(settings.getFillRActive(),
//                                 settings.getFillGActive(),
//                                 settings.getFillBActive());
  
//   color colorStrokeActive = color(settings.getStrokeRActive(),
//                                   settings.getStrokeGActive(),
//                                   settings.getStrokeBActive());
  
//   for (int i = 0; i < grid.getRows(); i++)
//   {
//     for (int j = 0; j < grid.getColumns(); j++)
//     {
//       int currentState = config.getCellState(i,j);
//       if (currentState == 1) // draw shapes only into active cells
//       {
//         // Setting PShape fill&stroke up
//         if (settings.isFillOnActive())
//           cellShape.setFill(colorFillActive);
//         else
//           cellShape.setFill(false);
//         if (settings.isStrokeOnActive())
//           cellShape.setStroke(colorStrokeActive);
//         else
//           cellShape.setStroke(false);

//         // Drawind shapes
//         PVector currentPoint = grid.getPoint(i,j);
//         ctx.shape(cellShape, currentPoint.x, currentPoint.y);
//       }
//     }
//   }
  
// }

void drawGrid(PGraphics ctx, Grid2D grid)
{
  int i, j;
  int rowPoints = grid.getRowPoints();
  int colPoints = grid.getColumnPoints();
  
  // Building rows
  for (i = 0; i < rowPoints; ++i)
  {
    for (j = 0; j < colPoints - 1; ++j)
    {
      PVector startingPoint = grid.getPoint(i, j);
      PVector endingPoint = grid.getPoint(i, j + 1);
      
      ctx.stroke(204, 204, 204);
      ctx.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
    }
  }

  // Building cols
  for (i = 0; i < colPoints; ++i)
  {
    for (j = 0; j < rowPoints - 1; ++j)
    {
      PVector startingPoint = grid.getPoint(j, i);
      PVector endingPoint = grid.getPoint(j + 1, i);

      ctx.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
    }
  }
}

void drawGollyPattern(PGraphics ctx,
                      Grid2D grid,
                      GollyRleConfiguration config,
                      GollyPatternSettings settings)
{  
  /* retrieving sizes */
  int gridRows = grid.getRows();
  int gridCols = grid.getColumns();
  int matrixRows = config.getMatrixHeight();
  int matrixCols = config.getMatrixWidth();
  
  /* computing offsets */
  int xOffset = ceil(abs(gridRows - matrixRows) / 2);
  int yOffset = ceil(abs(gridCols - matrixCols) / 2);
  
  //println("OFFSET", gridRows, gridCols, matrixRows, matrixCols, xOffset, yOffset);
  
  /* getting grid sub indices */
  int startX = (matrixRows < gridRows) ? xOffset : 0;
  int endX = min(matrixRows, gridRows);
  int startY = (matrixCols < gridCols) ? yOffset : 0;
  int endY = min(matrixCols, gridCols);
  
  //println("STEND ", startX, endX, startY, endY);
  
  color colorFillActive = color(settings.getFillRActive(),
                                settings.getFillGActive(),
                                settings.getFillBActive());
  
  color colorStrokeActive = color(settings.getStrokeRActive(),
                                  settings.getStrokeGActive(),
                                  settings.getStrokeBActive());
  
  for (int i = startX; i < endX; i++)
  {
    for (int j = startY; j < endY; j++)
    {
      /* get matrix indices */
      int mi = (matrixRows > gridRows)? i + xOffset : i - xOffset; // you cannot increment array index indefinitely
      int mj = (matrixCols > gridCols)? j + yOffset : j - yOffset; // ..maybe this is what you meant?

      // c'è ancora qualcosa che non va

      // if (i==startX && j==startY) println(mi,mj);
      // if (i==endX-1 && j==endY-1) println(mi,mj);
      
      int currentState = config.getCellState(mi, mj);
      PVector currentPoint = grid.getPoint(i,j);

      if (currentState > 0) /* each state > 0 is considered active */
      {
        // Setting PShape fill&stroke up
        if (settings.isFillOnActive())
          ctx.fill(colorFillActive);
          //cellShape.setFill(colorFillActive);
        else
          ctx.noFill();
          //cellShape.setFill(false);
        if (settings.isStrokeOnActive())
          ctx.stroke(colorStrokeActive);
        //cellShape.setStroke(colorStrokeActive);
        else
          ctx.noStroke();
          //cellShape.setStroke(false);

        // Drawind shapes
        //ctx.shape(cellShape, currentPoint.x, currentPoint.y); fuck you
        ctx.rect(currentPoint.x, currentPoint.y, settings.getShapeWidth(), settings.getShapeHeight());
      }
      else /* inactive state */
      {
      
      }
    }
  }
  
}

// PShape generateShape(float w, float h,
//                      CellShape shapeType, String SVGPath)
// {
//   PShape patternShape = createShape();
//   switch(shapeType)
//   {
//   case SQUARE: // to be correct, this is a generic rect
//     // patternShape.beginShape();
//     // patternShape.vertex(0,0);
//     // patternShape.vertex(0,w);
//     // patternShape.vertex(w,h);
//     // patternShape.vertex(h,0);
//     // patternShape.vertex(0,0);
//     // patternShape.endShape();
//      patternShape = createShape(RECT,0,0,w,h);
//     break;
//   case CIRCLE:
//     patternShape = createShape(ELLIPSE,0,0,w,h);
//     // circles are not so easy to draw using curveVertex()..
//     // ..but we can build very complex shapes in the future
//     break;
//   case CUSTOM:
//     patternShape = loadShape(SVGPath); // todo: resize svg
//     break;
//   }
//   return patternShape;
// }

void exportNow(String pdfFile)
{
  /* gathering info */
  int cols = currentGrid.getColumns();
  int rows = currentGrid.getRows();
  float cellWidth = currentGrid.getCellWidth();
  float cellHeight = currentGrid.getCellHeight();
  float shapeWidth = currentSettings.getShapeWidth();
  float shapeHeight = currentSettings.getShapeHeight();

  /* Compute pdf size */
  int pdfWidth = (ceil(cols * cellWidth) + ceil(shapeWidth-cellWidth)) + (int)(2 * pdfBorder);
  int pdfHeight = (ceil(rows * cellHeight) + ceil(shapeHeight-cellHeight)) + (int)(2 * pdfBorder);
  
  /* setting up pdf */
  PGraphics pdf = createGraphics(pdfWidth, pdfHeight, PDF, pdfFile+".pdf");
  
  /* rendering */
  pdf.beginDraw();

  /* displacing by borders */
  pdf.translate(pdfBorder,pdfBorder);

  /* drawing */
  drawGollyPattern(pdf, currentGrid, currentConfig, currentSettings);
  
  pdf.dispose();

  /* goodbye */
  pdf.endDraw();
  
}

void draw()
{
  if (initedDrawing)
  {
    /* Loading current transformer */
    transformer = currentSettings.getTransformer();

    /* getting ready for drawing */
    transformer.startDrawing();

    /* Refreshing bg */
    background(bg);
  
    /* are we ready to draw? */
    drawGrid(g, currentGrid);
    drawGollyPattern(g, currentGrid, currentConfig, currentSettings);

    /* ended drawing */
    transformer.endDrawing();
  }
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

void generateGridFrom(GollyRleConfiguration config)
{
  PVector origin = new PVector();
  
  int cols = config.getMatrixWidth();
  int rows = config.getMatrixHeight();

  float cellWidth = cellDim;
  float cellHeight = cellDim;

  currentGrid = new Grid2D(origin, cols, rows, cellWidth, cellHeight);
  
  /* Adding grid to history */
  manager.addGrid(currentGrid);
}

void initConfiguration(GollyRleConfiguration configuration)
{
  /* Adding config history */
  manager.addConfiguration(configuration);
  
  /* Generating grid from it (then adding it to history) */
  generateGridFrom(configuration);
  
  /* Can we enable nextConfig button? */
  checkConfigHistory();
  
  /* Associating default settings to config */
  currentSettings = new GollyPatternSettings();
  manager.addSettings(currentSettings); // start pattern with defaults
  
  /* Init GUI controls */
  manageControls(false);
  
  /* Init SketchTransformer */
  currentSettings.initTransformer((width-sizeCP5Group)/2, height/2, 1.0);
  
  /* Loading current transformer */
  transformer = currentSettings.getTransformer();
  
  /* Centering sketch */
  centerSketch();
  
  /* Enabling drawing */
  initedDrawing = true;
}

/* Golly file loader */
void loadGollyRle()
{
  /* Trying to get configuration from parser */
  try
  {
    /* Load clipboard content if any otherwise go with file */
    if (pastedMessage != null)
    {
      currentConfig = reader.parseString(pastedMessage);
    }
    else
      currentConfig = reader.parseFile(gollyFilePath);

    /* Init current configuration */
    initConfiguration(currentConfig);
    
  }
  catch (RuntimeException e)
  {
    e.printStackTrace();
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
    showPopup("Giovani, qui accettiamo solo file in formato RLE di Golly!\n\n");
  }
  catch (IOException e)
  {
    System.err.println("ERROR: " + e.getMessage());
  }
  finally
  {
    pastedMessage = null; // reset
  }
}

void centerSketch()
{
  /* gathering info */
  int cols = currentGrid.getColumns();
  int rows = currentGrid.getRows();
  float cellWidth = currentGrid.getCellWidth();
  float cellHeight = currentGrid.getCellHeight();
  float shapeWidth = currentSettings.getShapeWidth();
  float shapeHeight = currentSettings.getShapeHeight();
  
  /* computing pattern size */
  float patternWidth = cols * cellWidth + (shapeWidth-cellWidth);
  float patternHeight = rows * cellHeight + (shapeHeight-cellHeight);
  
  /* centering sketch */
  transformer.centerSketch(width,sizeCP5Group,height,0,patternWidth,patternHeight);
}

String GetTextFromClipboard()
{
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
  return text;
}

Object GetFromClipboard(DataFlavor flavor)
{
  Clipboard clipboard = getToolkit().getSystemClipboard();
  Transferable contents = clipboard.getContents(null);
  Object obj = null;
  if (contents != null && contents.isDataFlavorSupported(flavor))
  {
    try
    {
      obj = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException exu) // Unlikely but we must catch it
    {
      println("Unsupported flavor: " + exu);
//~ exu.printStackTrace();
    }
    catch (java.io.IOException exi)
    {
      println("Unavailable data: " + exi);
//~ exi.printStackTrace();
    }
  }
  return obj;
} 


void center(int value)
{
  centerSketch();
}

void mousePressed()
{
  if (initedDrawing)
  {
    if (mouseX < x - sizeCP5Group) // avoid sliders conflict
      transformer.saveMousePosition(mouseX, mouseY);
  }
}

void mouseReleased()
{
  if (initedDrawing)
  {
    transformer.resetMousePosition();
  }
}

void mouseDragged()
{
  if (initedDrawing)
  {
    //if (mouseX < x - sizeCP5Group) // avoid sliders conflict
    transformer.updateTranslationOffset(mouseX, mouseY);
  }
}


boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];  
  }
  return false;
}
 
void keyPressed()
{ 
  keys[keyCode] = true;
  //println(KeyEvent.getKeyText(keyCode));
  if(checkKey(KeyEvent.VK_META) && checkKey(KeyEvent.VK_W))
  {
    pastedMessage = GetTextFromClipboard();
    loadGollyRle();
  }
}
 
void keyReleased()
{ 
  keys[keyCode] = false; 
}

// void keyPressed()
// {
//   if (key == 0x16) // Ctrl+v
//   {
//     pastedMessage = GetTextFromClipboard();
//     println(pastedMessage);
//   }
// }

// void keyReleased()
// {
// }

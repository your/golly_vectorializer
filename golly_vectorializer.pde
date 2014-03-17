/** What did I do:
 * 1. Added drawShape() using (faster?) P2D rendering engine needed for PShape
 *    (http://www.processing.org/tutorials/pshape/);
 *    (I had to add a CellShape.java containing CellShape enum (che brutta cosa))
 * 2. Added CP5 controls (stub) and a custom Class (it extends a CP5 one)
 * 3. Added dragging of pattern grid
 * 4. Added methods to get and set origin to Grid2D.pde class
 * 5. Added Config and Settings arrayList to HistoryManager (to handle history still)
 * 6. Added Alert Box on wrong file input (stub)
 * 7. minor changes
 */
import java.io.*;
import java.util.*;
import controlP5.*;

/** Management global variables */
GollyRleReader reader;
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;
Grid2D currentGrid;
ControlP5 cp5;
Group mainG, lockG;

/** Default window/drawing settings */
int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int cellDim = 10;
float xO = 10;
float yO = 10;
color bg = color(255);
boolean builtSliders = false;

/** Pattern drag'n'drop vars */
float xOffset = 0.0;
float yOffset = 0.0;
boolean overGrid = false;
boolean lockedGrid = false;

void setup()
{
  /** Setting up main display settings */
  smooth();
  frameRate(30);
  
  size(x,y,P2D);
  background(bg);

  /** Building CP5 objects */
  cp5 = new ControlP5(this);
  mainG = cp5.addGroup("mainControls")
    .setPosition(width-sizeCP5Group,0)
    .setSize(sizeCP5Group,height)
    .setBackgroundColor(color(0,0,0,50))
    ;
  lockG = cp5.addGroup("lockBox")
    .setSize(width,height)
    .setPosition(0,0)
    .setBackgroundColor(color(10,0,10,200))
    .hide()
    ;
  cp5.addButton("loadRleConfig")
    .setLabel("Aggiungi File RLE di Golly")
    .setPosition(40,20)
    .setSize(110,19)
    .moveTo(mainG)
    ;
  cp5.addButton("rewindConfigHistory")
    .setLabel("< prev")
    .setPosition((width-sizeCP5Group)/2-20,height-50)
    .setSize(35,25)
    ;
  cp5.addButton("forwardConfigHistory")
    .setLabel("next >")
    .setPosition((width-sizeCP5Group)/2+20,height-50)
    .setSize(35,25)
    ;
  
  /** Global objects init */
  manager = new GollyHistoryManager();
  reader = new GollyRleReader();
  currentSettings = new GollyPatternSettings();
}

void buildSliders()
{
  if (!builtSliders)
  {
    ResizableColorPicker cp5e;
    Group gridG = cp5.addGroup("gridControls")
      .setPosition(10,100)
      .setSize(180,60)
      .setBackgroundColor(color(20,0,20,150))
      .setLabel("Impostazioni Griglia").setColorBackground(color(10,0,10,200))
      .moveTo(mainG)
      ;
    Group settG = cp5.addGroup("settControls")
      .setPosition(10,200)
      .setSize(180,100)
      .setBackgroundColor(color(20,0,20,150))
      .setLabel("Impostazioni Pattern").setColorBackground(color(10,0,10,200))
      .moveTo(mainG)
      ;
    
    cp5.addTextlabel("resizeCells")
      .setPosition(2,10)
      .setText("DIMENSIONE CELLE")
      .moveTo(gridG)
      ;
    cp5.addSlider("cellWidth")
      .setValue(currentGrid.getCellWidth())
      .setLabel("L")
      .setPosition(2,25)
      .setSize(165,10)
      .setRange(0,200)
      .moveTo(gridG)
      ;
    cp5.addSlider("cellHeight")
      .setValue(currentGrid.getCellHeight())
      .setLabel("A")
      .setPosition(2,40)
      .setSize(165,10)
      .setRange(0,200)
      .moveTo(gridG)
      ;

    cp5.addTextlabel("pickerFillLabel")
      .setPosition(2,10)
      .setText("COLORE CELLE ATTIVE")
      .moveTo(settG)
      ;
    // color pickers (resizeble)
    cp5e = new ResizableColorPicker(cp5,"pickerFillActive");
    cp5e.setPosition(2,25)
      .setColorValue(color(currentSettings.getFillRActive(),
                           currentSettings.getFillGActive(),
                           currentSettings.getFillBActive()))
      .moveTo(settG)
      ;
    cp5e.setItemSize(175,10);
    
    builtSliders = true;
  }
}

void buildPopup() {
  Group winG =
    cp5.addGroup("messageBox")
    .setLabel("ERRORE")
    .setPosition(width/2-150,height/2-150)
    .setSize(300,300)
    .setBackgroundHeight(120)
    .setBackgroundColor(color(0,100))
    .moveTo(lockG)
    //.hideBar()
    ;

  cp5.addTextlabel("messageBoxLabel",
                   "Giovani, qui accettiamo solo file in formato RLE di Golly!\n\n"+
                   "(In alternativa provate a dropparli o copia-incollarli)",30,30)
    .moveTo(winG)
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

  lockG.show();
}

/** CP5 class extends */
class ResizableColorPicker extends ColorPicker
{
  ResizableColorPicker(ControlP5 cp5, String theName)
  {
    super(cp5, cp5.getTab("default"), theName, 0, 0, 100, 10);
  }
  void setItemSize(int w, int h)
  {
    sliderRed.setSize(w, h);
    sliderGreen.setSize(w, h);
    sliderBlue.setSize(w, h);
    sliderAlpha.setSize(w, h);
   
    // you gotta move the sliders as well or they will overlap
    sliderGreen.setPosition(PVector.add(sliderGreen.getPosition(), new PVector(0, h-10)));
    sliderBlue.setPosition(PVector.add(sliderBlue.getPosition(), new PVector(0, 2*(h-10))));
    sliderAlpha.setPosition(PVector.add(sliderAlpha.getPosition(), new PVector(0, 3*(h-10))));
  }
}
  
/** CP5 objects callbacks */
void cellWidth(int val)
{
  currentGrid.setCellWidth(val);
}
void cellHeight(int val)
{
  currentGrid.setCellHeight(val);
}
void forwardConfigHistory(int status)
{
  manager.forwardConfigHistory();
  manager.forwardGridHistory();
}
void rewindConfigHistory(int status)
{
  manager.rewindConfigHistory();
  manager.rewindGridHistory();
}
void loadRleConfig(int status)
{
  selectInput("Selezionare un file RLE di Golly:", "fileSelected");
}
void buttonOk(int theValue) {
  lockG.hide();
}
void pickerFillActive(int val)
{
  currentSettings.setFillRActive((int)red(val));
  currentSettings.setFillGActive((int)green(val));
  currentSettings.setFillBActive((int)blue(val));
  /** Adding settings to history */
  manager.addSettings(currentSettings); // todo: handle settings history
}

/** Processing file selection callback */
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
  PVector origin = new PVector(xO,yO); // default origin todo: center it
  int cols = config.getMatrixWidth();
  int rows = config.getMatrixHeight();

  float cellWidth = cellDim;
  float cellHeight = cellDim;

  Grid2D genGrid = new Grid2D(origin, cols, rows, cellWidth, cellHeight); 
  /** Adding grid to history */
  manager.addGrid(genGrid);
  
}

/** Drawing methods */
void drawGollyPattern(PGraphics ctx,
                      Grid2D grid,
                      GollyRleConfiguration config,
                      GollyPatternSettings settings)
{
  float cellWidth = grid.getCellWidth();
  float cellHeight = grid.getCellHeight();
  
  color colorFill = color(settings.getFillRActive(),
                          settings.getFillGActive(),
                          settings.getFillBActive());
  color colorStroke = color(settings.getStrokeRActive(),
                            settings.getStrokeGActive(),
                            settings.getStrokeBActive());
  
  /** Setting up shape */
  PShape cellShape = null;
  // fill and stroke colors
  fill(colorFill);
  stroke(colorStroke);
  //noStroke();
  switch(settings.getCellShape())
  {
  case SQUARE:
    cellShape = createShape(RECT,0,0,cellWidth,cellHeight);
    break;
  case CIRCLE:
    cellShape = createShape(ELLIPSE,0,0,cellWidth,cellHeight);
    break;
  case CUSTOM:
    String svg = settings.getSVGPath();
    cellShape = loadShape(svg); // todo: resize svg
    break;
  }
  /** Drawing shapes */
  drawShape(ctx, cellShape, grid, config);
}

void drawShape(PGraphics ctx, PShape s, Grid2D grid, GollyRleConfiguration config)
{
  for (int i = 0; i < grid.getRows(); i++)
  {
    for (int j = 0; j < grid.getColumns(); j++)
    {
      int currentState = config.getCellState(i,j);
      if (currentState == 1) // draw shapes only into active cells
      {
        PVector currentPoint = grid.getPoint(i,j);
        ctx.shape(s, currentPoint.x, currentPoint.y);
      }
    }
  }  
}

void draw()
{
  /** Refreshing bg */
  background(bg);
  /** Getting current history snapshot */
  currentConfig = manager.getCurrentConfiguration();
  currentGrid = manager.getCurrentGrid();
  currentSettings = manager.getCurrentSettings();
  if (currentConfig != null && currentGrid != null) // cannot ever be null if loadGollyFile() has been called
  {
    drawGollyPattern(g, currentGrid, currentConfig, currentSettings);
    buildSliders();
  }
  
  //Test if the cursor is over the pattern grid
  if (currentGrid != null)
  {
    float xO = currentGrid.getX0();
    float yO = currentGrid.getY0();
    float gridWidth = currentGrid.getCellWidth() * currentGrid.getRows();
    float gridHeight = currentGrid.getCellHeight() * currentGrid.getColumns();

    if (mouseX > xO - gridWidth && mouseX < xO + gridWidth &&
        mouseX < x - sizeCP5Group && // make sure we are not on CP5 controllers
        mouseY > yO - gridHeight && mouseY < yO + gridHeight)
    {
      overGrid = true;
      if(!lockedGrid)
      {
        //stroke(255);
        //fill(153);
      }
    }
    else
    {
      //stroke(153);
      //fill(153);
      overGrid = false;
    }
  }
  //drawGuiElements
  //
}

/** Golly file loader */
void loadGollyFile(String gollyFile)
{
  /** Trying to get configuration from parser */
  try
  {
    GollyRleConfiguration newConfig = reader.parseFile(gollyFile);
    /** Adding it to history */
    manager.addConfiguration(newConfig);
    /** Generating grid from it (then adding it to history) */
    generateGridFrom(newConfig);
    /** Adding default settings to history */
    manager.addSettings(new GollyPatternSettings()); // start pattern with defaults
  }
  catch (RuntimeException e)
  {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
    buildPopup();
  }
  catch (IOException e)
  {
    System.err.println("ERROR: " + e.getMessage());
  }
}

/** Mouse events */
void mousePressed()
{
  if (currentGrid != null)
  {
    if(overGrid)
    { 
      lockedGrid = true; 
      //fill(255, 255, 255);
    }
    else
    {
      lockedGrid = false;
    }
    xOffset = mouseX - currentGrid.getX0();
    yOffset = mouseY - currentGrid.getY0();
  }
}
void mouseDragged()
{
  if (currentGrid != null)
  {
    if(lockedGrid)
    {
      currentGrid.setX0(mouseX-xOffset); 
      currentGrid.setY0(mouseY-yOffset); 
    }
  }
}
void mouseReleased()
{
  if (currentGrid != null)
  {
    lockedGrid = false;
  }
}

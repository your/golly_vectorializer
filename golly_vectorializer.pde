import java.io.*;
import java.util.*;
import java.net.*;
import controlP5.*;
import sojamo.drop.*;
import java.nio.file.*;
import processing.pdf.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.KeyEvent;
import java.security.CodeSource;

/* Global variables */
GollyRleReader reader;
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;
SketchTransformer transformer;
Grid2D currentGrid;
ControlP5 cp5;
CDrawable[] d;
SDrop drop;
// ResizableColorPicker cp5e;
Group mainG, gridG, settG, lockG, winG;
String gollyFilePath = null;
String pastedMessage;
String pdfFile;
boolean[] keys = new boolean[526];

/* Default window/drawing settings */
int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int cellDim = 10;
int popupXSize, popupYSize = 0;
float scaleUnit = 0.05;
float pdfBorder = 5.0;
color bg = color(255);
color cp = color(10, 20, 10, 200);
color cq = color(200, 180, 200, 100);
boolean popupOn = false;
boolean draggingOn = false;

/* Spinning wheel vars */
float[] arcStartPositions = new float[3];
float arcBoundSize, arcMaxBoundSize = 80;
boolean loadingSomething = false;

/* Application Updater stuff */
ApplicationUpdater updater;
String remoteHost = "mm.sharped.net";
int remotePort = 3300;
String remoteScript = "cgi-bum/mmupdate.icg";
String remotePath = "cgi-bum/release/golly_vectorializer.app/Contents/Java/";

/* color palette stub, each pattern can have its own as a setting */
ColorPalette palette;
int paletteColors = 7;


void manageControls(boolean lock)
{
  /* Locking/unlocking controls */
  // mainG
  setLock(cp5.getController("exportToPDF"), lock);
  // gridG
  setLock(cp5.getController("cellWidth"), lock);
  setLock(cp5.getController("cellHeight"), lock);
  setLock(cp5.getController("inputCellWidth"), lock);
  setLock(cp5.getController("inputCellHeight"), lock);
  setLock(cp5.getController("toggleKeepCellRatio"), lock);
  setLock(cp5.getController("toggleShowGrid"), lock);
  setLock(cp5.getController("toggleShowInactives"), lock);
  setLock(cp5.getController("zoomIn"), lock);
  setLock(cp5.getController("zoomOut"), lock);
  setLock(cp5.getController("zoomSlider"), lock);
  setLock(cp5.getController("center"), lock);
  setLock(cp5.getController("scaleIn"), lock);
  setLock(cp5.getController("scaleOut"), lock);
  // settG
  setLock(cp5.getController("rowsNum"), lock); // temp disabled
  setLock(cp5.getController("colsNum"), lock); // temp disabled
  setLock(cp5.getController("shapeWidth"), lock);
  setLock(cp5.getController("shapeHeight"), lock);
  setLock(cp5.getController("inputShapeWidth"), lock);
  setLock(cp5.getController("inputShapeHeight"), lock);
  setLock(cp5.getController("toggleKeepShapeRatio"), lock);
  setLock(cp5.getController("toggleShapesLikeCells"), lock);
  setLock(cp5.getController("openPalette"), lock);
  // setLock(cp5.getController("pickRFill"), lock);
  // setLock(cp5.getController("pickGFill"), lock);
  // setLock(cp5.getController("pickBFill"), lock);
  // setLock(cp5.getController("pickAFill"), lock);
  // setLock(cp5.getController("inputRFill"), lock);
  // setLock(cp5.getController("inputGFill"), lock);
  // setLock(cp5.getController("inputBFill"), lock);
  // setLock(cp5.getController("inputAFill"), lock);
  setLock(cp5.getController("toggleFill"), lock);
  setLock(cp5.getController("pickRStroke"), lock);
  setLock(cp5.getController("pickGStroke"), lock);
  setLock(cp5.getController("pickBStroke"), lock);
  setLock(cp5.getController("pickAStroke"), lock);
  setLock(cp5.getController("toggleStroke"), lock);
  setLock(cp5.getController("toggleWorkingStates"), lock);
  
  if (!lock)
  {
    /* Colouring sliders if unlocked */
    // cp5.getController("pickRFill").setColorBackground(color(200, 20, 40));
    // cp5.getController("pickGFill").setColorBackground(color(20, 200, 40));
    // cp5.getController("pickBFill").setColorBackground(color(40, 20, 200));
    // cp5.getController("pickAFill").setColorBackground(color(100, 100, 100));
    cp5.getController("pickRStroke").setColorBackground(color(200, 20, 40));
    cp5.getController("pickGStroke").setColorBackground(color(20, 200, 40));
    cp5.getController("pickBStroke").setColorBackground(color(40, 20, 200));
    cp5.getController("pickAStroke").setColorBackground(color(100, 100, 100));

    // cp5 is da shit; I need to start triggering toggle events only when
    // all the cp5 controllers set up by updateControls() are unlocked;
    // in this specific case, the problem was that the event triggered by
    // toggleWorkingStates called updateControls(), and I cant touch
    // *TOGGLE* controls value until they are unlocked. Thus adding:
    cp5.getController("toggleWorkingStates").setBroadcast(true);
    cp5.getController("toggleKeepShapeRatio").setBroadcast(true);
    cp5.getController("toggleShapesLikeCells").setBroadcast(true);
  }
}
void updateControls()
{
  // temp disable broadcast to avoid values r/w conflicts
  cp5.getController("rowsNum").setBroadcast(false);
  cp5.getController("colsNum").setBroadcast(false);
  cp5.getController("toggleKeepCellRatio").setBroadcast(false);
  cp5.getController("toggleShowGrid").setBroadcast(false);
  cp5.getController("toggleShowInactives").setBroadcast(false);
  cp5.getController("zoomSlider").setBroadcast(false);
  // doing stuff on controls
  cp5.getController("rowsNum").setValue(currentGrid.getRows());
  cp5.getController("colsNum").setValue(currentGrid.getColumns());
  cp5.getController("cellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("cellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("inputCellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("inputCellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("toggleKeepCellRatio").setValue(currentSettings.getKeepCellRatio() ? 1 : 0);
  cp5.getController("toggleShowGrid").setValue(currentSettings.getShowGrid()?1:0);
  cp5.getController("toggleShowInactives").setValue(currentSettings.getShowInactives() ? 1 : 0);
  cp5.getController("zoomSlider").setValue(transformer.getScaleFactor() * 100);
  cp5.getController("zoomPercentage").setStringValue((int)(transformer.getScaleFactor() * 100) + "%");
  cp5.getController("scaleFactor").setStringValue((int)(currentSettings.getScaleFactor()) + "x");
  // broadcasting values again
  cp5.getController("rowsNum").setBroadcast(true);
  cp5.getController("colsNum").setBroadcast(true);
  cp5.getController("toggleKeepCellRatio").setBroadcast(true);
  cp5.getController("toggleShowGrid").setBroadcast(true);
  cp5.getController("toggleShowInactives").setBroadcast(true);
  cp5.getController("zoomSlider").setBroadcast(true);

  // this shit needs to be broadcasted off
  cp5.getController("toggleFill").setBroadcast(false);
  cp5.getController("toggleStroke").setBroadcast(false);
  cp5.getController("toggleKeepShapeRatio").setBroadcast(false);
  cp5.getController("toggleShapesLikeCells").setBroadcast(false);
  
  if (currentSettings.workingOnActiveStates())
  {
    cp5.getController("shapeWidth").setValue(currentSettings.getShapeWidthActive());
    cp5.getController("shapeHeight").setValue(currentSettings.getShapeHeightActive());
    cp5.getController("inputShapeWidth").setValue(currentSettings.getShapeWidthActive());
    cp5.getController("inputShapeHeight").setValue(currentSettings.getShapeHeightActive());
    cp5.getController("toggleKeepShapeRatio").setValue(currentSettings.getKeepShapeRatioActive() ? 1 : 0);
    cp5.getController("toggleShapesLikeCells").setValue(currentSettings.getShapesLikeCellsActive() ? 1 : 0);
    // ensure we get the updated locks
    if (currentSettings.getShapesLikeCellsActive())
    {
      setLock(cp5.getController("shapeWidth"), true);
      setLock(cp5.getController("shapeHeight"), true);
    }
    else
    {
      setLock(cp5.getController("shapeWidth"), false);
      setLock(cp5.getController("shapeHeight"), false);
    }
    // cp5.getController("pickRFill").setValue(currentSettings.getFillRActive());
    // cp5.getController("pickGFill").setValue(currentSettings.getFillGActive());
    // cp5.getController("pickBFill").setValue(currentSettings.getFillBActive());
    // cp5.getController("pickAFill").setValue(currentSettings.getFillAActive());
    // cp5.getController("inputRFill").setValue(currentSettings.getFillRActive());
    // cp5.getController("inputGFill").setValue(currentSettings.getFillGActive());
    // cp5.getController("inputBFill").setValue(currentSettings.getFillBActive());
    // cp5.getController("inputAFill").setValue(currentSettings.getFillAActive());
    cp5.getController("toggleFill").setValue(currentSettings.isFillOnActive() ? 1 : 0);
    cp5.getController("pickRStroke").setValue(currentSettings.getStrokeRActive());
    cp5.getController("pickGStroke").setValue(currentSettings.getStrokeGActive());
    cp5.getController("pickBStroke").setValue(currentSettings.getStrokeBActive());
    cp5.getController("pickAStroke").setValue(currentSettings.getStrokeAActive());
    cp5.getController("toggleStroke").setValue(currentSettings.isStrokeOnActive() ? 1 : 0);
  }
  else
  {
    cp5.getController("shapeWidth").setValue(currentSettings.getShapeWidthInactive());
    cp5.getController("shapeHeight").setValue(currentSettings.getShapeHeightInactive());
    cp5.getController("inputShapeWidth").setValue(currentSettings.getShapeWidthInactive());
    cp5.getController("inputShapeHeight").setValue(currentSettings.getShapeHeightInactive());
    cp5.getController("toggleKeepShapeRatio").setValue(currentSettings.getKeepShapeRatioInactive() ? 1 : 0);
    cp5.getController("toggleShapesLikeCells").setValue(currentSettings.getShapesLikeCellsInactive() ? 1 : 0);
    // ensure we get the updated locks
    if (currentSettings.getShapesLikeCellsInactive())
    {
      setLock(cp5.getController("shapeWidth"), true);
      setLock(cp5.getController("shapeHeight"), true);
    }
    else
    {
      setLock(cp5.getController("shapeWidth"), false);
      setLock(cp5.getController("shapeHeight"), false);
    }
    // cp5.getController("pickRFill").setValue(currentSettings.getFillRInactive());
    // cp5.getController("pickGFill").setValue(currentSettings.getFillGInactive());
    // cp5.getController("pickBFill").setValue(currentSettings.getFillBInactive());
    // cp5.getController("pickAFill").setValue(currentSettings.getFillAInactive());
    // cp5.getController("inputRFill").setValue(currentSettings.getFillRInactive());
    // cp5.getController("inputGFill").setValue(currentSettings.getFillGInactive());
    // cp5.getController("inputBFill").setValue(currentSettings.getFillBInactive());
    // cp5.getController("inputAFill").setValue(currentSettings.getFillAInactive());
    cp5.getController("toggleFill").setValue(currentSettings.isFillOnInactive() ? 1 : 0);
    cp5.getController("pickRStroke").setValue(currentSettings.getStrokeRInactive());
    cp5.getController("pickGStroke").setValue(currentSettings.getStrokeGInactive());
    cp5.getController("pickBStroke").setValue(currentSettings.getStrokeBInactive());
    cp5.getController("pickAStroke").setValue(currentSettings.getStrokeAInactive());
    cp5.getController("toggleStroke").setValue(currentSettings.isStrokeOnInactive() ? 1 : 0);
  }

  // broadcasting again
  cp5.getController("toggleFill").setBroadcast(true);
  cp5.getController("toggleStroke").setBroadcast(true);
  cp5.getController("toggleKeepShapeRatio").setBroadcast(true);
  cp5.getController("toggleShapesLikeCells").setBroadcast(true);

}
void setup()
{   
  /* Setting up main display settings */
  smooth();
  frameRate(30);

  size(x, y);

  drop = new SDrop(this);

  background(bg);

  /* palette stuff */
  d = new CDrawable[paletteColors];
  palette = new ColorPalette(paletteColors);

  /* setting just the first three colors */
  color rc = color(23, 123, 123);
  color gc = color(180, 45, 11);
  color bc = color(123, 100, 89);
  color tc = color(34, 55, 89);
  color zc = color(222, 90, 111);
  color mc = color(4, 34, 230);
  
  palette.setColor(0, rc);
  palette.setColor(1, gc);
  palette.setColor(2, bc);
  palette.setColor(3, tc);
  palette.setColor(4, zc);
  palette.setColor(5, zc);
  
  /* init ApplicationUpdater */
  CodeSource codeSource =
    golly_vectorializer.class.getProtectionDomain().getCodeSource();
  updater = new ApplicationUpdater(remoteHost, remotePort,
                                   remoteScript, remotePath, codeSource);

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
    .setPosition(width-sizeCP5Group, 0)
    .setSize(sizeCP5Group, height)
    //.setBackgroundColor(color(0,0,0,0))
    ;
  // GRID SUBGROUP AREA
  gridG = cp5.addGroup("gridControls")
    .setPosition(10, 130)
    .setSize(180, 250)
    .setBackgroundColor(color(1, 108, 158))
    //.setBackgroundColor(color(20,0,20,150))
    //.setBackgroundColor(color(175,190,175,220))
    .setLabel("Impostazioni Griglia").setColorBackground(color(10, 0, 10, 200))
    .moveTo(mainG)
    ;
  cp5.addTextlabel("resizeGrid")
    .setPosition(5, 10)
    .setText("DIMENSIONE GRIGLIA")
    .moveTo(gridG)
    ;
  cp5.addSlider("rowsNum")
    .setLabel("ROWS")
    .setPosition(5, 25)
    .setSize(145, 10)
    .setValue(currentGrid.getRows())
    .setRange(0, 1000)
    .moveTo(gridG)
    ;
  cp5.addSlider("colsNum")
    .setLabel("COLS")
    .setPosition(5, 36)
    .setSize(145, 10)
    .setValue(currentGrid.getColumns())
    .setRange(0, 1000)
    .moveTo(gridG)
    ;
  cp5.addTextlabel("resizeCells")
    .setPosition(5, 60)
    .setText("DIMENSIONE CELLE")
    .moveTo(gridG)
    ;
  cp5.addTextfield("inputCellWidth")
    .setLabel("")
    .setPosition(140,75)
    .setSize(35,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.FLOAT)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(gridG)
    ;
  cp5.addSlider("cellWidth")
    .setLabel("L")
    .setPosition(5, 75)
    .setSize(123, 10)
    .setValue(currentGrid.getCellWidth())
    .setRange(0, 200)
    .moveTo(gridG)
    ;
  cp5.addTextfield("inputCellHeight")
    .setLabel("")
    .setPosition(140,86)
    .setSize(35,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.FLOAT)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(gridG)
    ;
  cp5.addSlider("cellHeight")
    .setLabel("A")
    .setPosition(5, 86)
    .setSize(123, 10)
    .setValue(currentGrid.getCellHeight())
    .setRange(0, 200)
    .moveTo(gridG)
    ;
  cp5.addToggle("toggleKeepCellRatio")
    .setLabel("Mantieni rapporto")
    .setPosition(5, 98)
    .setSize(42, 15)
    .setValue(currentSettings.getKeepCellRatio())
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
  cp5.addToggle("toggleShowGrid")
    .setLabel("Disegna Griglia")
    .setPosition(5, 210)
    .setSize(42, 15)
    .setValue(currentSettings.getShowGrid())
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
  cp5.addToggle("toggleShowInactives")
    .setLabel("Disegna celle inattive")
    .setPosition(80, 210)
    .setSize(42, 15)
    .setValue(currentSettings.getShowInactives())
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
  cp5.addButton("zoomIn")
    .setLabel("Zoom +")
    .setPosition(75, 140)
    .setSize(35, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addButton("zoomOut")
    .setLabel("Zoom -")
    .setPosition(115, 140)
    .setSize(35, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addSlider("zoomSlider")
    .setLabel("Zoom")
    .setPosition(5, 157)
    .setSize(145, 20)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .setValue(100)
    .setRange(1, 500)
    .moveTo(gridG)
    ;
  cp5.addTextlabel("zoomPercentage")
    .setText("100%")
    .setPosition(150, 143)
    .setSize(35, 15)
    .moveTo(gridG)
    ;
  cp5.addButton("center")
    .setLabel("Centrami!").align(0, 0, ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 183)
    .setSize(55, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addButton("scaleIn")
    .setLabel("Scala+")
    .setPosition(75, 183)
    .setSize(35, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addButton("scaleOut")
    .setLabel("Scala-")
    .setPosition(115, 183)
    .setSize(35, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
  cp5.addTextlabel("scaleFactor")
    .setText("1x")
    .setPosition(150, 187)
    .setSize(35, 15)
    .moveTo(gridG)
    ;
  // SETTINGS SUBGROUP AREA
  settG = cp5.addGroup("settControls")
    .setPosition(10, 395)
    .setSize(180, 340)
    .setBackgroundColor(color(1, 108, 158))
    //.setBackgroundColor(color(175,190,175,220))
    //.setBackgroundColor(color(20,0,20,150))
    //.setBackgroundColor(color(0,0,0,220))
    .setLabel("Impostazioni Pattern").setColorBackground(color(10, 0, 10, 200))
    .moveTo(mainG)
    ;
  // SHAPES AREA
  cp5.addTextlabel("resizeShapes")
    .setPosition(5, 10)
    .setText("DIMENSIONE FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addTextfield("inputShapeWidth")
    .setLabel("")
    .setPosition(140,25)
    .setSize(35,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.FLOAT)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("shapeWidth")
    .setLabel("L")
    .setPosition(5, 25)
    .setSize(123, 10)
    //.setValue(currentSettings.getShapeWidth())
    .setRange(0, 200)
    .moveTo(settG)
    ;
  cp5.addTextfield("inputShapeHeight")
    .setLabel("")
    .setPosition(140,36)
    .setSize(35,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.FLOAT)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("shapeHeight")
    .setLabel("A")
    .setPosition(5, 36)
    .setSize(123, 10)
    //.setValue(currentSettings.getShapeHeight())
    .setRange(0, 200)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleKeepShapeRatio")
    .setLabel("Mantieni Rapporto")
    .setPosition(5, 48)
    .setSize(42, 15)
    .setBroadcast(false)
    //.setValue(currentSettings.getKeepShapeRatio())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleShapesLikeCells")
    .setLabel("Copia Dimensioni Celle")
    .setPosition(85, 48)
    .setSize(63, 15)
    .setBroadcast(false)
    //.setValue(currentSettings.getShapesLikeCells())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  cp5.addTextlabel("paletteLabel")
    .setPosition(5, 90)
    .setText("PALETTE FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addButton("openPalette")
    .setLabel("APRI PALETTE").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(50, 105)
    .setSize(80, 20)
    .setColorBackground(cp)
    .moveTo(settG)
    ;
  cp5.addTextlabel("pickerFillLabel")
    .setPosition(5, 135)
    .setText("RIEMPIMENTO FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addToggle("toggleWorkingStates")
    .setLabel("Impostazioni stati attivi")
    .setPosition(40, 300)
    .setSize(100, 15)
    .setBroadcast(false) // needed as explained above
    .setValue(currentSettings.workingOnActiveStates()) // def
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  // cp5.addTextfield("inputRFill")
  //   .setLabel("")
  //   .setPosition(150,105)
  //   .setSize(25,11)
  //   .setColorBackground(0)
  //   .setInputFilter(ControlP5.INTEGER)
  //   .setFocus(false)
  //   .setAutoClear(false)
  //   .setColor(color(255,0,0))
  //   .setColorActive(255)
  //   .moveTo(settG)
  //   ;
  // cp5.addSlider("pickRFill")
  //   .setLabel("R")
  //   .setPosition(5, 105)
  //   .setSize(132, 10)
  //   //.setColorValue(currentSettings.getFillRActive())
  //   //.setValue(currentSettings.getFillRActive())
  //   .setColorForeground(color(255, 255, 255))
  //   .setRange(0, 255)
  //   .moveTo(settG)
  //   ;
  // cp5.addTextfield("inputGFill")
  //   .setLabel("")
  //   .setPosition(150,116)
  //   .setSize(25,11)
  //   .setColorBackground(0)
  //   .setInputFilter(ControlP5.INTEGER)
  //   .setFocus(false)
  //   .setAutoClear(false)
  //   .setColor(color(255,0,0))
  //   .setColorActive(255)
  //   .moveTo(settG)
  //   ;
  // cp5.addSlider("pickGFill")
  //   .setLabel("G")
  //   .setPosition(5, 116)
  //   .setSize(132, 10)
  //   //.setColorValue(currentSettings.getFillGActive())
  //   .setColorForeground(color(255, 255, 255))
  //   .setRange(0, 255)
  //   .moveTo(settG)
  //   ;
  // cp5.addTextfield("inputBFill")
  //   .setLabel("")
  //   .setPosition(150,127)
  //   .setSize(25,11)
  //   .setColorBackground(0)
  //   .setInputFilter(ControlP5.INTEGER)
  //   .setFocus(false)
  //   .setAutoClear(false)
  //   .setColor(color(255,0,0))
  //   .setColorActive(255)
  //   .moveTo(settG)
  //   ;
  // cp5.addSlider("pickBFill")
  //   .setLabel("B")
  //   .setPosition(5, 127)
  //   .setSize(132, 10)
  //   //.setColorValue(currentSettings.getFillBActive())
  //   .setColorForeground(color(255, 255, 255))
  //   .setRange(0, 255)
  //   .moveTo(settG)
  //   ;
  // cp5.addTextfield("inputAFill")
  //   .setLabel("")
  //   .setPosition(150,138)
  //   .setSize(25,11)
  //   .setColorBackground(0)
  //   .setInputFilter(ControlP5.INTEGER)
  //   .setFocus(false)
  //   .setAutoClear(false)
  //   .setColor(color(255,0,0))
  //   .setColorActive(255)
  //   .moveTo(settG)
  //   ;
  // cp5.addSlider("pickAFill")
  //   .setLabel("A")
  //   .setPosition(5, 138)
  //   .setSize(132, 10)
  //   //.setColorValue(currentSettings.getFillAActive())
  //   .setColorForeground(color(255, 255, 255))
  //   .setRange(0, 255)
  //   .moveTo(settG)
  //   ;
  cp5.addToggle("toggleFill")
    .setLabel("Riempimento ON")
    .setPosition(5, 150)
    .setSize(42, 15)
    .setValue(currentSettings.isFillOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
  cp5.addTextlabel("pickerStrokeLabel")
    .setPosition(5, 195)
    .setText("CONTORNO FORME ATTIVE")
    .moveTo(settG)
    ;
  cp5.addSlider("pickRStroke")
    .setLabel("R")
    .setPosition(5, 210)
    .setSize(160, 10)
    //.setColorValue(currentSettings.getStrokeRActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGStroke")
    .setLabel("G")
    .setPosition(5, 221)
    .setSize(160, 10)
    //.setColorValue(currentSettings.getStrokeGActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBStroke")
    .setLabel("B")
    .setPosition(5, 232)
    .setSize(160, 10)
    //.setColorValue(currentSettings.getStrokeBActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAStroke")
    .setLabel("A")
    .setPosition(5, 243)
    .setSize(160, 10)
    //.setColorValue(currentSettings.getStrokeAActive())
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
  cp5.addToggle("toggleStroke")
    .setLabel("Contorno ON")
    .setPosition(5, 255)
    .setSize(42, 15)
    .setValue(currentSettings.isStrokeOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;

  // cp5e = new ResizableColorPicker(cp5,"pickerFill");
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
    .setSize(width, height)
      .setPosition(0, 0)
        .setBackgroundColor(color(10, 0, 10, 200))
          .hide()
            ;
  // LOAD RLE AREA
  cp5.addButton("loadRleConfig")
    .setLabel("Aggiungi Golly RLE").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
      .setPosition(40, 20)
        .setSize(110, 19)
          .setColorBackground(cp)
            .moveTo(mainG)
              ;
  cp5.addButton("exportToPDF").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setLabel("Esporta in PDF")
      .setPosition(40, 43)
        .setSize(110, 19)
          .setColorBackground(cp)
            .moveTo(mainG)
    ;
  cp5.addButton("checkForUpdate")
    .setLabel("Controlla Aggiornamenti").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(40, 70)
    .setSize(110, 19)
    .setColorBackground(cp)
    .moveTo(mainG)
    ;
  // HISTORY AREA
  cp5.addButton("rewindConfigHistory")
    .setLabel("< prev")
      .setPosition((width-sizeCP5Group)/2-20, height-50)
        .setColorBackground(cq)
          .setSize(35, 25)
            ;
  cp5.addButton("forwardConfigHistory")
    .setLabel("next >")
      .setPosition((width-sizeCP5Group)/2+20, height-50)
        .setColorBackground(cq)
          .setSize(35, 25)
            ;

  /* History starting locks */
  setLock(mainG.getController("rewindConfigHistory"), true);
  setLock(mainG.getController("forwardConfigHistory"), true);

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
  cp5.addTextlabel("labelPalettePreview")
    .setValue("Anteprime:")
    .setPosition(30,60)
    .setSize(10,10)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor1")
    .setLabel("Stato 1")
    .setPosition(100,80)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor2")
    .setLabel("Stato 2")
    .setPosition(100,120)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor3")
    .setLabel("Stato 3")
    .setPosition(100,160)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor4")
    .setLabel("Stato 4")
    .setPosition(100,200)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor5")
    .setLabel("Stato 5")
    .setPosition(100,240)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor6")
    .setLabel("Stato 6")
    .setPosition(100,280)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addTextfield("inputPaletteColor7")
    .setLabel("Stato 7")
    .setPosition(100,320)
    .setSize(50,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
  cp5.addButton("buttonGenericCancel")
    .setPosition(160,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Annulla").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .hide()
    ;
  cp5.addButton("buttonGenericOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Ok").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonOverwriteOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Sovrascrivi").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonDownloadUpdateOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Scarica").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonApplyUpdateOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Riavvia ora").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonApplyUpdateCancel")
    .setPosition(160,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Riavvia dopo").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonPaletteOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Salva").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
  cp5.addButton("buttonPaletteCancel")
    .setPosition(160,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Annulla").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ; 

  /* Message box is shown only upon request */
  winG.hide();

  /* Lock controls @startup */
  manageControls(true);

  /* test if any update downloaded has to be applied */
  updateReady(false); // true to enable startup updates
  
}

/* Will draw pgraphics objects into cp5 layers (workaround) */
void setDrawable(int objNum,
                 final int xOffset, final int yOffset,
                 final int xWidth, final int yHeight,
                 final color fillColor) {
  d[objNum] = new CDrawable() {    
    public void draw(PApplet p) {
      p.pushMatrix();
      p.translate(xOffset, yOffset);
      p.fill(fillColor);
      p.rect(0, 0, xWidth, yHeight);
      p.popMatrix();
    }
  };
}

/* HEX stuff utilities */
color getColorFromHex(String hexString) {
  // n.b. input hex has to miss 0x or such
  int unhexed = unhex(hexString);
  float r = red(unhexed);
  float g = green(unhexed);
  float b = blue(unhexed);
  color newColor = color(r, g, b);
  return newColor;
}
String sanitizeHexInput(String hexInput) {
  // n.b. will cut down 0x or # @ beginning if any
  if (hexInput.startsWith("0x"))
    hexInput = hexInput.substring(2, hexInput.length());
  else if (hexInput.startsWith("#"))
    hexInput = hexInput.substring(1, hexInput.length());
  hexInput = hexInput.replaceAll("[^a-fA-F0-9]", "");
  int endIdx = hexInput.length() <= 6 ? hexInput.length() : 6;
  hexInput = hexInput.substring(0, endIdx);
  return hexInput;
}

void inputPaletteColor1(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor1"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(0);
}
void inputPaletteColor2(String val) {
  if (val != "") {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor2"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(1);
  }
}
void inputPaletteColor3(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor3"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(2);
}
void inputPaletteColor4(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor4"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(3);
}
void inputPaletteColor5(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor5"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(4);
}
void inputPaletteColor6(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor6"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(5);
}
void inputPaletteColor7(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor7"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(6);
}
void updatePaletteDrawable(int number) {
  String currentInput = "inputPaletteColor" + (number + 1);
  String stringColor = cp5.getController(currentInput).getStringValue();
  color newColor = getColorFromHex(stringColor);
  winG.remove(d[number]);
  setDrawable(number, 50, 80 + (40 * number), 10, 10, newColor);
  winG.addDrawable(d[number]);
}
void savePalette() {
  for (int i = 0; i < paletteColors; i++) {
    String currentInput = "inputPaletteColor" + (i + 1);
    String stringColor = cp5.getController(currentInput).getStringValue();
    if (stringColor != "") {
      color newColor = getColorFromHex(stringColor);
      palette.setColor(i, newColor);
    }
  }
}
void openPalette(int value) {
  showPopup("Inserire gli esadecimali per ogni stato:\n(dare INVIO ad ogni inserimento!)", 300, 420, 4, 2);
  showPalette();
}
void showPalette() {
  winG.controller("labelPalettePreview").show();
  for (int i = 0; i < paletteColors; i++) {
    String currentInput = "inputPaletteColor" + (i + 1);
    Textfield content = ((Textfield)cp5.getController(currentInput));
    String hexedColor = hex(palette.getColor(i));
    content.setValue(hexedColor.substring(2));
    winG.controller(currentInput).show();
  }
  setDrawable(0, 50, 80, 10, 10, palette.getColor(0));
  setDrawable(1, 50, 120, 10, 10, palette.getColor(1));
  setDrawable(2, 50, 160, 10, 10, palette.getColor(2));
  setDrawable(3, 50, 200, 10, 10, palette.getColor(3));
  setDrawable(4, 50, 240, 10, 10, palette.getColor(4));
  setDrawable(5, 50, 280, 10, 10, palette.getColor(5));
  setDrawable(6, 50, 320, 10, 10, palette.getColor(6));
  winG.addDrawable(d[0]);
  winG.addDrawable(d[1]);
  winG.addDrawable(d[2]);
  winG.addDrawable(d[3]);
  winG.addDrawable(d[4]);
  winG.addDrawable(d[5]);
  winG.addDrawable(d[6]);
}
void killPalette() {
  // if you are asking, no, it wont work in a loop...
  // (cp5 oddities....)
  winG.remove(d[0]);
  winG.remove(d[1]);
  winG.remove(d[2]);
  winG.remove(d[3]);
  winG.remove(d[4]);
  winG.remove(d[5]);
  winG.remove(d[6]);
  winG.controller("labelPalettePreview").hide();
  winG.controller("inputPaletteColor1").hide();
  winG.controller("inputPaletteColor2").hide();
  winG.controller("inputPaletteColor3").hide();
  winG.controller("inputPaletteColor4").hide();
  winG.controller("inputPaletteColor5").hide();
  winG.controller("inputPaletteColor6").hide();
  winG.controller("inputPaletteColor7").hide();
}
void buttonPaletteOK() {
  savePalette();
  killPalette();
  killPopup();
}
void buttonPaletteCancel() {
  killPalette();
  killPopup();
}
void resetPopup() {
  // reset buttons
  winG.controller("buttonGenericOK").hide();
  winG.controller("buttonOverwriteOK").hide();
  winG.controller("buttonDownloadUpdateOK").hide();
  winG.controller("buttonApplyUpdateOK").hide();
  winG.controller("buttonGenericCancel").hide();
  winG.controller("buttonApplyUpdateCancel").hide();
  winG.controller("buttonPaletteOK").hide();
  winG.controller("buttonPaletteCancel").hide();
}
void showPopup(String message, int xSize, int ySize, int buttonA, int buttonB) {
  popupXSize = xSize;
  popupYSize = ySize;
  showPopup(message, buttonA, buttonB);
}
void showPopup(String message, int buttonA, int buttonB) {
  if (popupXSize == 0 && popupYSize == 0) {

    /* adapting popup size and position to its msg content */
    Scanner in = new Scanner(message);
    int lines = 0;
    int chars = 0;
    while(in.hasNextLine()) {
      lines++;
      String line = in.nextLine();
      chars = line.length() > chars? line.length() : chars;
    }
    popupXSize = chars * 5 + 20;
    popupXSize = popupXSize > 300 ? popupXSize : 300; // not going under 300p in width
    popupYSize = lines * 40;
  }
  
  cp5.group("messageBox").setPosition((width - popupXSize) / 2 - 50,
                                      (height - popupYSize) / 2 - 50);
  cp5.group("messageBox").setSize(popupXSize, popupYSize);
  
  lockG.show();
  cp5.addTextlabel("messageBoxLabel")
    .setValue(message)
    .setPosition(30,30)
    .setSize(popupXSize - 10, popupYSize - 10)
    .moveTo(winG)
    ;

  resetPopup();

  /// button A
  // 0: genericOK
  // 1: overwriteOK
  // 2: downloadUpdateOK
  // 3: applyUpdateOK
  // 4: paletteOK

  /// button B
  // 0: genericCancel
  // 1: applyUpdateCancel
  // 2: paletteCancel
  
  switch(buttonA) {
  case 0:
    cp5.controller("buttonGenericOK").setPosition(popupXSize / 2 - 100,
                                                  popupYSize - 45);
    cp5.controller("buttonGenericOK").show();
    break;
  case 1:
    cp5.controller("buttonOverwriteOK").setPosition(popupXSize / 2 - 100,
                                                    popupYSize - 45);
    cp5.controller("buttonOverwriteOK").show();
    break;
  case 2:
    cp5.controller("buttonDownloadUpdateOK").setPosition(popupXSize / 2 - 100,
                                                         popupYSize - 45);
    cp5.controller("buttonDownloadUpdateOK").show();
    break;
  case 3:
    cp5.controller("buttonApplyUpdateOK").setPosition(popupXSize / 2 - 100,
                                                      popupYSize - 45);
    cp5.controller("buttonApplyUpdateOK").show();
    break;
  case 4:
    cp5.controller("buttonPaletteOK").setPosition(popupXSize / 2 - 100,
                                                  popupYSize - 45);
    cp5.controller("buttonPaletteOK").show();
  }

  switch(buttonB) {
  case 0:
    cp5.controller("buttonGenericCancel").setPosition(popupXSize / 2 + 25,
                                                      popupYSize - 45);
    cp5.controller("buttonGenericCancel").show();
    break;
  case 1:
    cp5.controller("buttonApplyUpdateCancel").setPosition(popupXSize / 2 + 25,
                                                          popupYSize - 45);
    cp5.controller("buttonApplyUpdateCancel").show();
    break;
  case 2:
    cp5.controller("buttonPaletteCancel").setPosition(popupXSize / 2 + 25,
                                                      popupYSize - 45);
    cp5.controller("buttonPaletteCancel").show();
  }
  
  winG.show();
  popupOn = true;
  
  // resetting those
  popupXSize = 0;
  popupYSize = 0;
}

void killPopup()
{
  winG.getController("messageBoxLabel").remove();
  winG.hide();
  lockG.hide();
  popupOn = false;
}

boolean fileExists(String filename) {

  File file = new File(filename);

  if (!file.exists())
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
  if (theValue)
  {
    theController.setColorBackground(cq);
  }
  else
  {
    theController.setColorBackground(cp);
  }
}

void toggleWorkingStates(boolean flag)
{
  currentSettings.setWorkingOnActiveStates(flag);
  String status = flag? "ATTIV" : "INATTIV";
  mainG.getController("toggleWorkingStates").setLabel(
    "IMPOSTAZIONI STATI " + status + "I");
  mainG.getController("resizeShapes").setStringValue(
    "DIMENSIONI FORME " + status + "E");
  mainG.getController("pickerFillLabel").setStringValue(
    "RIEMPIMENTO FORME " + status + "E");
  mainG.getController("pickerStrokeLabel").setStringValue(
    "CONTORNO FORME " + status + "E");
  updateControls();
}

/* CP5 objects callbacks */
void rowsNum(int val)
{
  currentGrid.setRows(val);
  if (currentSettings.getTransformer() != null)
    centerSketch();
}
void colsNum(int val)
{
  currentGrid.setColumns(val);
  if (currentSettings.getTransformer() != null)
    centerSketch();
}
void cellWidth(float val) {
  currentGrid.setCellWidth(val);
  if (currentSettings.getKeepCellRatio())
    currentGrid.setCellHeight(val);
  if (currentSettings.workingOnActiveStates())
  {
    if (currentSettings.getShapesLikeCellsActive())
    {
      currentSettings.setShapeWidthActive(currentGrid.getCellWidth());
      currentSettings.setShapeHeightActive(currentGrid.getCellHeight());
    }
  }
  else
  {
    if (currentSettings.getShapesLikeCellsInactive())
    {
      currentSettings.setShapeWidthInactive(currentGrid.getCellWidth());
      currentSettings.setShapeHeightInactive(currentGrid.getCellHeight());
    }
  }
  Textfield txt = ((Textfield)cp5.getController("inputCellWidth"));
  txt.setValue(String.format("%.2f", val));
}
void inputCellWidth(String val) {
  val = val.replace(',', '.');
  cp5.controller("cellWidth").setValue(float(val));
}
void cellHeight(float val) {
  currentGrid.setCellHeight(val);
  if (currentSettings.getKeepCellRatio())
    currentGrid.setCellWidth(val);
  if (currentSettings.workingOnActiveStates())
  {
    if (currentSettings.getShapesLikeCellsActive())
    {
      currentSettings.setShapeWidthActive(currentGrid.getCellWidth()); ////////
      currentSettings.setShapeHeightActive(currentGrid.getCellHeight());
    }
  }
  else
  {
    if (currentSettings.getShapesLikeCellsInactive())
    {
      currentSettings.setShapeWidthInactive(currentGrid.getCellWidth()); ////////
      currentSettings.setShapeHeightInactive(currentGrid.getCellHeight());
    }
  }
  Textfield txt = ((Textfield)cp5.getController("inputCellHeight"));
  txt.setValue(String.format("%.2f", val));
}
void inputCellHeight(String val) {
  val = val.replace(',', '.');
  cp5.controller("cellHeight").setValue(float(val));
}
void shapeWidth(float val) {
  if (currentSettings.workingOnActiveStates())
  {  
    currentSettings.setShapeWidthActive(val);
    if (currentSettings.getKeepShapeRatioActive())
      currentSettings.setShapeHeightActive(val);
  }
  else
  {
    currentSettings.setShapeWidthInactive(val);
    if (currentSettings.getKeepShapeRatioInactive())
      currentSettings.setShapeHeightInactive(val);
  }
  Textfield txt = ((Textfield)cp5.getController("inputShapeWidth"));
  txt.setValue(String.format("%.2f", val));
}
void inputShapeWidth(String val) {
  val = val.replace(',', '.');
  cp5.controller("shapeWidth").setValue(float(val));
}
void shapeHeight(float val) {
  if (currentSettings.workingOnActiveStates())
  {  
    currentSettings.setShapeHeightActive(val);
    if (currentSettings.getKeepShapeRatioActive())
      currentSettings.setShapeWidthActive(val);
  }
  else
  {
    currentSettings.setShapeHeightInactive(val);
    if (currentSettings.getKeepShapeRatioInactive())
      currentSettings.setShapeWidthInactive(val);
  }
  Textfield txt = ((Textfield)cp5.getController("inputShapeHeight"));
  txt.setValue(String.format("%.2f", val));
}
void inputShapeHeight(String val) {
  val = val.replace(',', '.');
  cp5.controller("shapeHeight").setValue(float(val));
}
void forwardConfigHistory(int status)
{
  manager.forwardHistory();
  updateHistory();
  updateControls();
}
void rewindConfigHistory(int status)
{
  manager.rewindHistory();
  updateHistory();
  updateControls();
}

void updateHistory()
{
  currentGrid = manager.getCurrentGrid();
  currentConfig = manager.getCurrentConfiguration();
  currentSettings = manager.getCurrentSettings();
  transformer = currentSettings.getTransformer();
  checkConfigHistory();
}
void loadRleConfig(int status)
{
  selectInput("Selezionare un file RLE di Golly:", "fileSelected");
}
void exportToPDF(int status)
{
  File defaultFile = createDefaultFile();
  selectOutput("Selezionare destinazione PDF:", "pdfSelected", defaultFile);
}
void checkForUpdate(boolean flag)
{
  updateReady(true);
}
void toggleShowGrid(boolean flag)
{
  currentSettings.setShowGrid(flag);
}
void toggleShowInactives(boolean flag)
{
  currentSettings.setShowInactives(flag);
}
void toggleKeepCellRatio(boolean flag)
{
  currentSettings.setKeepCellRatio(flag);
}
void toggleKeepShapeRatio(boolean flag)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setKeepShapeRatioActive(flag);
  else
    currentSettings.setKeepShapeRatioInactive(flag);
  updateControls();
}
void toggleShapesLikeCells(boolean flag)
{
  if (flag)
  {
    if (currentSettings.workingOnActiveStates())
    {
      currentSettings.setShapeWidthActive(currentGrid.getCellWidth());
      currentSettings.setShapeHeightActive(currentGrid.getCellHeight());
    }
    else
    {
      currentSettings.setShapeWidthInactive(currentGrid.getCellWidth());
      currentSettings.setShapeHeightInactive(currentGrid.getCellHeight());
    }
  }
  // setLock(cp5.getController("shapeWidth"), flag);
  // setLock(cp5.getController("shapeHeight"), flag);
  // ensure we have always data mirrored
  // cp5.getController("shapeWidth").setValue(currentGrid.getCellWidth());
  // cp5.getController("shapeHeight").setValue(currentGrid.getCellHeight());

  if (currentSettings.workingOnActiveStates())
    currentSettings.setShapesLikeCellsActive(flag);
  else
    currentSettings.setShapesLikeCellsInactive(flag);

  updateControls();
}
void toggleStroke(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleStroke").setLabel("Contorno " + status);
  if (currentSettings.workingOnActiveStates())
    currentSettings.setIsStrokeOnActive(flag);
  else
    currentSettings.setIsStrokeOnInactive(flag);
}
void toggleFill(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleFill").setLabel("Riempimento " + status);
  if (currentSettings.workingOnActiveStates())
    currentSettings.setIsFillOnActive(flag);
  else
    currentSettings.setIsFillOnInactive(flag);
}
void buttonOverwriteOK(boolean flag)
{
  exportNow();
  killPopup();
}
void buttonGenericOK(boolean flag) {
  killPopup();
}
void buttonGenericCancel(boolean flag)
{
  killPopup();
}
void buttonDownloadUpdateOK(boolean flag)
{
  killPopup();
  downloadUpdate();
}
void buttonApplyUpdateOK(boolean flag)
{
  killPopup();
  applyUpdate();
}
void buttonApplyUpdateCancel(boolean flag)
{
  killPopup();
  cp5.getController("checkForUpdate").remove();
  cp5.addButton("checkForUpdate")
    .setLabel("Riavvia e aggiorna").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(40, 66)
    .setSize(110, 19)
    .setColorBackground(cp)
    .moveTo(mainG)
    ;
}
void pickRFill(int val) {
  if (currentSettings.workingOnActiveStates())
    currentSettings.setFillRActive(val);
  else
    currentSettings.setFillRInactive(val);
  Textfield txt = ((Textfield)cp5.getController("inputRFill"));
  txt.setValue(Integer.toString(val));
}
void inputRFill(String val) {
  cp5.controller("pickRFill").setValue(int(val));
}
void pickGFill(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setFillGActive(val);
  else
    currentSettings.setFillGInactive(val);
  Textfield txt = ((Textfield)cp5.getController("inputGFill"));
  txt.setValue(Integer.toString(val));
}
void inputGFill(String val) {
  cp5.controller("pickGFill").setValue(int(val));
}
void pickBFill(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setFillBActive(val);
  else
    currentSettings.setFillBInactive(val);
  Textfield txt = ((Textfield)cp5.getController("inputBFill"));
  txt.setValue(Integer.toString(val));
}
void inputBFill(String val) {
  cp5.controller("pickBFill").setValue(int(val));
}
void pickAFill(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setFillAActive(val);
  else
    currentSettings.setFillAInactive(val);
  Textfield txt = ((Textfield)cp5.getController("inputAFill"));
  txt.setValue(Integer.toString(val));
}
void inputAFill(String val) {
  cp5.controller("pickAFill").setValue(int(val));
}
void pickRStroke(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setStrokeRActive(val);
  else
    currentSettings.setStrokeRInactive(val);
}
void pickGStroke(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setStrokeGActive(val);
  else
    currentSettings.setStrokeGInactive(val);
}
void pickBStroke(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setStrokeBActive(val);
  else
  currentSettings.setStrokeBInactive(val);
}
void pickAStroke(int val)
{
  if (currentSettings.workingOnActiveStates())
    currentSettings.setStrokeAActive(val);
  else
    currentSettings.setStrokeAInactive(val);
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
  mainG.getController("zoomPercentage").setStringValue(percentage + "%");
  updateControls();
  // cp5.remove("zoomPercentage");
  // cp5.addTextlabel("zoomPercentage")
  //   .setText(percentage + "%")
  //   .setPosition(150,113)
  //   .setSize(35,15)
  //   .moveTo(gridG)
  //   ;
}

void zoomSlider(int value)
{
  float scaleFactor = (float)value / 100; 
  //scaleFactor += scaleUnit;
  if (currentSettings.getTransformer() != null)
  {
    transformer.setScaleFactor(scaleFactor);
    centerSketch();
    updateZoomPercentage();
  }
  //updateControls();
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

void updateScale(float newScale)
{
  mainG.getController("scaleFactor").setStringValue((int)newScale + "x");
  updateControls();
}
  
void scaleIn(int value)
{
  if(currentConfig != null)
  {
    float currentScaleFactor = currentSettings.getScaleFactor();
    float newScaleFactor = 2 * currentScaleFactor;
    
    /* updating scale right now */
    currentSettings.setScaleFactor(newScaleFactor);
    
    scaleConfiguration(2); // default multiplier

    updateScale(newScaleFactor);
  }
}

void scaleOut(int value)
{
  if(currentConfig != null)
  {
    float currentScaleFactor = currentSettings.getScaleFactor();
    float newScaleFactor = currentScaleFactor == 1? 1 : currentScaleFactor / 2;
    
    /* updating scale right now */
    currentSettings.setScaleFactor(newScaleFactor);
    
    scaleConfiguration(currentScaleFactor == 1? 1 : 0.5f);

    updateScale(newScaleFactor);
  }
}
// void scaleOut(int value)
// {
//   if(currentConfig != null)
//   {
//     float currentScaleFactor = currentSettings.getScaleFactor();
//     float newScaleFactor = currentScaleFactor == 1? 1 : currentScaleFactor / 2;
//     println(currentScaleFactor, newScaleFactor);

//     /* updating scale right now */
//     currentSettings.setScaleFactor(newScaleFactor);

//     /* overwriting current config */
//     GollyRleConfiguration x2Config =
//       currentConfig.newScaledConfiguration(currentScaleFactor == 1? 1 : 0.5f);

//     /* overwriting current config */
//     overwriteConfiguration(x2Config);

//     updateScale(newScaleFactor);
//   }
// }

File createDefaultFile()
{
  File defaultFile = null;
  
  /* an rle file has been selected */
  String currentRlePath = currentSettings.getRleFilePath();
  if(currentRlePath != null)
  {
    println("Current path ", currentRlePath);
    /* get the filename */
    int index = currentRlePath.lastIndexOf(File.separator);
    
    String filename = currentRlePath.substring(index + 1);
    println("Current filename", filename);
    /* removing the extension */
    index = filename.lastIndexOf(".rle");
    String rawName = filename.substring(0, index);
    println("Current rawname ", rawName);
    
    defaultFile = new File(rawName);
  }
    
  return defaultFile;
}

/* Processing file selection callback */
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
    gollyFilePath = selection.getAbsolutePath();
    println("User selected " + gollyFilePath);
    loadGollyRle();
  }
}
void pdfSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    pdfFile = selection.getAbsolutePath() + ".pdf";
    println("User selected " + pdfFile);
    if (!fileExists(pdfFile)) exportNow();
    else showPopup("Ao, questo file PDF esiste gia'!\n\nSovrascriverlo?", 1, 0);
  }
}

// boolean fileExist(String fileName)
// {
//   boolean canOverwrite = true;
//   Path filePath = Paths.get(fileName);
//   println(filePath);
//   if (Files.exists(filePath))
    
//   else
// }

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


// void drawGrid(PGraphics ctx, Grid2D grid)
// {
//   int i, j;
//   int rowPoints = grid.getRowPoints();
//   int colPoints = grid.getColumnPoints();
  
//   // Building rows
//   for (i = 0; i < rowPoints; ++i)
//   {
//     for (j = 0; j < colPoints - 1; ++j)
//     {
//       PVector startingPoint = grid.getPoint(i, j);
//       PVector endingPoint = grid.getPoint(i, j + 1);
      
//       ctx.stroke(204, 204, 204);
//       ctx.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
//     }
//   }

//   // Building cols
//   for (i = 0; i < colPoints; ++i)
//   {
//     for (j = 0; j < rowPoints - 1; ++j)
//     {
//       PVector startingPoint = grid.getPoint(j, i);
//       PVector endingPoint = grid.getPoint(j + 1, i);

//       ctx.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
//     }
//   }
// }

void drawInactiveCellStub(PGraphics ctx, PVector point,
                          GollyPatternSettings settings)
{
  color colorFillInactive = color(settings.getFillRInactive(), 
                                  settings.getFillGInactive(), 
                                  settings.getFillBInactive());

  color colorStrokeInactive = color(settings.getStrokeRInactive(), 
                                    settings.getStrokeGInactive(), 
                                    settings.getStrokeBInactive());
  if (settings.isFillOnInactive())
    ctx.fill(colorFillInactive);
  else
    ctx.noFill();
  if (settings.isStrokeOnInactive())
    ctx.stroke(colorStrokeInactive);
  else
    ctx.noStroke();
  
  ctx.rect(point.x, point.y,
           currentSettings.getShapeWidthInactive(),
           currentSettings.getShapeHeightInactive());
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

  // println("OFFSET", gridRows, gridCols, matrixRows, matrixCols, xOffset, yOffset);

  /* getting grid sub indices */
  int minRows = min(matrixRows, gridRows);
  int minCols = min(matrixCols, gridCols);
  int startX = (matrixRows < gridRows) ? xOffset : 0;
  int endX = (matrixRows < gridRows) ? minRows + xOffset : minRows;
  int startY = (matrixCols < gridCols) ? yOffset : 0;
  int endY = (matrixCols < gridCols) ? minCols + yOffset : minCols;

  // println("STEND ", startX, endX, startY, endY);

  color colorFillActive = color(settings.getFillRActive(), 
  settings.getFillGActive(), 
  settings.getFillBActive());

  color colorStrokeActive = color(settings.getStrokeRActive(), 
  settings.getStrokeGActive(), 
  settings.getStrokeBActive());

  //  for (int i = startX; i < endX; i++)
  //  {
  //    for (int j = startY; j < endY; j++)
  //    {
  for (int i = 0; i < gridRows; i++)
  {
    for (int j = 0; j < gridCols; j++)
    {
      PVector currentPoint = grid.getPoint(i, j);

      /* is pointer inside matrix? */
      if (i >= startX && i < endX && j >= startY && j < endY)
      {

        /* get matrix indices */
         int mi = (matrixRows > gridRows)? i + xOffset : i - xOffset; // you cannot increment array index indefinitely
         int mj = (matrixCols > gridCols)? j + yOffset : j - yOffset; // ..maybe this is what you meant?

        // c'è ancora qualcosa che non va

        // if (i==startX && j==startY) println(mi,mj);
        // if (i==endX-1 && j==endY-1) println(mi,mj);

        int currentState = config.getCellState(mi, mj);

        if (currentState > 0) /* each state > 0 is considered active */
        {
          // Setting PShape fill&stroke up
          if (settings.isFillOnActive())
          {
            //ctx.fill(colorFillActive);
            ctx.fill(palette.getColor(currentState - 1));
          }
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
          ctx.rect(currentPoint.x, currentPoint.y, settings.getShapeWidthActive(), settings.getShapeHeightActive());
        }
        else /* inactive state */
        {
          if (currentSettings.getShowInactives())
            drawInactiveCellStub(ctx, currentPoint, settings);
        }
      }
      else /* fake inactive cell */
      {
        if (currentSettings.getShowInactives())
          drawInactiveCellStub(ctx, currentPoint, settings);
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

void exportNow()
{
  loadingSomething = true;
  
  /* gathering info */
  int cols = currentGrid.getColumns();
  int rows = currentGrid.getRows();
  float cellWidth = currentGrid.getCellWidth();
  float cellHeight = currentGrid.getCellHeight();
  float shapeWidth =
    (currentSettings.getShapeWidthActive() > currentSettings.getShapeWidthInactive())?
    currentSettings.getShapeWidthActive() : currentSettings.getShapeWidthInactive();
  float shapeHeight =
    (currentSettings.getShapeHeightActive() > currentSettings.getShapeHeightInactive())?
    currentSettings.getShapeHeightActive() : currentSettings.getShapeHeightInactive();

  /* Compute pdf size */
  int pdfWidth = (ceil(cols * cellWidth) + ceil(shapeWidth-cellWidth)) + (int)(2 * pdfBorder);
  int pdfHeight = (ceil(rows * cellHeight) + ceil(shapeHeight-cellHeight)) + (int)(2 * pdfBorder);

  /* setting up pdf */
  PGraphics pdf = createGraphics(pdfWidth, pdfHeight, PDF, pdfFile);
  
  /* rendering */
  pdf.beginDraw();

  /* displacing by borders */
  pdf.translate(pdfBorder,pdfBorder);

  /* drawing */
  drawGollyPattern(pdf, currentGrid, currentConfig, currentSettings);

  pdf.dispose();

  /* goodbye */
  pdf.endDraw();

  loadingSomething = false;
}

void draw()
{
  /* Refreshing bg */
  background(bg);
  
  if (loadingSomething)
    drawLoadingWheel(g);
  else
  {
  
    if (currentSettings.getTransformer() != null)
    {

      if (loadingSomething)
        drawLoadingWheel(g);
      else
      {
        /* getting ready for drawing */
        transformer.startDrawing();
      
        /* are we ready to draw? */
        if (currentSettings.getShowGrid()) currentGrid.draw(g, color(204, 204, 204));
        drawGollyPattern(g, currentGrid, currentConfig, currentSettings);

        /* ended drawing */
        transformer.endDrawing();
      }
    }
  }
}

void drawLoadingWheel(PGraphics ctx)
{
  ctx.background(210, 210, 210);
  arcBoundSize = arcMaxBoundSize;
  for (float s : arcStartPositions){
    float arcLength = random(PI, 8 * PI / 6);
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    ctx.stroke(c);
    ctx.noFill();
    ctx.arc((width - sizeCP5Group) / 2 + arcMaxBoundSize / 2,
            height / 2 - arcMaxBoundSize / 2,
            arcBoundSize, arcBoundSize, s, s + arcLength);
    arcBoundSize -= 10;
  }
  for (int i = 0; i < arcStartPositions.length; i++)
    arcStartPositions[i] += PI / 8;
}

void checkConfigHistory()
{
  println(currentConfig);
  /* Config history handling */
  if (manager.hasPrevConfig())
    setLock(mainG.getController("rewindConfigHistory"), false);
  else
    setLock(mainG.getController("rewindConfigHistory"), true);
  if (manager.hasNextConfig())
    setLock(mainG.getController("forwardConfigHistory"), false);
  else
    setLock(mainG.getController("forwardConfigHistory"), true);
}

Grid2D generateGridFrom(GollyRleConfiguration config)
{
  PVector origin = new PVector();

  int cols = config.getMatrixWidth();
  int rows = config.getMatrixHeight();

  float cellWidth = cellDim;
  float cellHeight = cellDim;

  Grid2D genGrid = new Grid2D(origin, cols, rows, cellWidth, cellHeight);

  return genGrid;
}

void scaleConfiguration(float newScaleFactor)
{
  GollyRleConfiguration newConfig = currentConfig.newScaledConfiguration(newScaleFactor);
  Grid2D newGrid = generateGridFrom(newConfig);
 
  /* overwriting configuration */
  manager.setCurrentConfiguration(newConfig);
  currentConfig = manager.getCurrentConfiguration();
  
  /* overwriting grid */
  manager.setCurrentGrid(newGrid);
  currentGrid = manager.getCurrentGrid();
  
  /* settings are kept */
}

void initConfiguration(GollyRleConfiguration configuration)
{
  /* Adding config history */
  manager.addConfiguration(configuration);

  /* Generating grid from it (then adding it to history) */
  currentGrid = generateGridFrom(configuration);
  /* Adding grid to history */
  manager.addGrid(currentGrid);

  /* Can we enable nextConfig button? */
  checkConfigHistory();

  /* Associating default settings to config */
  currentSettings = new GollyPatternSettings();
  currentSettings.setRleFilePath(gollyFilePath);
  
  manager.addSettings(currentSettings); // start pattern with defaults

  /* Init GUI controls */
  manageControls(false);

  /* Init SketchTransformer */
  currentSettings.initTransformer((width-sizeCP5Group)/2, height/2, 1.0);

  /* Loading current transformer */
  transformer = currentSettings.getTransformer();

  /* Centering sketch */
  centerSketch();
}

/* Golly file loader */
void loadGollyRle()
{
  /* Trying to get configuration from parser */
  try
  {
    loadingSomething = true; ///
    
    /* Load clipboard content if any otherwise go with file */
    if (pastedMessage != null)
    {
      currentConfig = reader.parseString(pastedMessage);
      gollyFilePath = null;
    }
    else
    {
      currentConfig = reader.parseFile(gollyFilePath);
    }
    
    /* Init current configuration */
    initConfiguration(currentConfig);

    /* da shit */
    updateControls();
  }
  catch (RuntimeException e)
  {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
    showPopup("Giovani, qui accettiamo solo file in formato RLE di Golly!\n\n", 0, -1);
  }
  catch (IOException e)
  {
    System.err.println("ERROR: " + e.getMessage());
  }
  finally
  {
    pastedMessage = null; // reset
    loadingSomething = false; ///
  }
}

void checkForUpdate()
{
  try {
    if (updater.updateAvailable()) {
      showPopup("E' disponibile un aggiornamento!\n\nScaricarlo?", 2, 0);
    } else {
      showPopup("Nessun aggiornamento disponibile!", 0, -1);
    }
  } catch(Exception e) {
    showPopup("Non sono riuscito a verificare la presenza di aggiornamenti:(\n\n" +
              e.getMessage(), 0, -1);
  }
}
void downloadUpdate()
{
  try {
    updater.downloadUpdate();
    if (updater.updateReady()) {
      showPopup("L'aggiornamento e' pronto!\nE' necessario il riavvio del programma.\n\n" +
                "Riavviare adesso? (se no, sara' installato al prossimo avvio)", 3, 1);
    }
  } catch(Exception e) {
    showPopup("Non sono riuscito a scaricare l'aggiornamento:(\n\n" +
              e.getMessage(), 0, -1);
  }
}
void applyUpdate()
{
  try {
    updater.applyUpdate();
    if (updater.updateSuccessfull()) {
      showPopup("L'ultimo aggiornamento è stato installato con successo! :D", 0, -1);
    } else {
      showPopup("Sì e' verificato un errore durante l'aggiornamento :O", 0, -1);
    }
  } catch(Exception e) {
    showPopup("Sì e' verificato un errore durante l'aggiornamento :O\n\n" +
              e.getMessage(), 0, -1);
  }
}
void updateReady(boolean checkNow)
{
  if (updater.updateReady())
    applyUpdate();
  else
    if (checkNow)
      checkForUpdate();
}

void centerSketch()
{
  /* gathering info */
  int cols = currentGrid.getColumns();
  int rows = currentGrid.getRows();
  float cellWidth = currentGrid.getCellWidth();
  float cellHeight = currentGrid.getCellHeight();
  float shapeWidth =
    (currentSettings.getShapeWidthActive() > currentSettings.getShapeWidthInactive())?
    currentSettings.getShapeWidthActive() : currentSettings.getShapeWidthInactive();
  float shapeHeight =
    (currentSettings.getShapeHeightActive() > currentSettings.getShapeHeightInactive())?
    currentSettings.getShapeHeightActive() : currentSettings.getShapeHeightInactive();

  /* computing pattern size */
  float patternWidth = cols * cellWidth + (shapeWidth-cellWidth);
  float patternHeight = rows * cellHeight + (shapeHeight-cellHeight);

  /* centering sketch */
  transformer.centerSketch(width, sizeCP5Group, height, 0, patternWidth, patternHeight);
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
  if (draggingOn)
    draggingOn = false;
//  popupOn = lockG.isVisible(); // update this guy at each press
  if (mouseX < x - sizeCP5Group)
  {
    if (currentSettings.getTransformer() != null && !popupOn)
    { 
      transformer.saveMousePosition(mouseX, mouseY);
    }
  }
}

PVector getPointInMatrix(PVector point,
                         Grid2D grid, 
                         GollyRleConfiguration config)
{
  PVector matrixPoint = new PVector();
  
  /* retrieving sizes */
  int gridRows = grid.getRows();
  int gridCols = grid.getColumns();
  int matrixRows = config.getMatrixHeight();
  int matrixCols = config.getMatrixWidth();

  /* computing offsets */
  int xOffset = ceil(abs(gridRows - matrixRows) / 2);
  int yOffset = ceil(abs(gridCols - matrixCols) / 2);

  int i = (int)point.x;
  int j = (int)point.y;

  matrixPoint.x = (matrixRows > gridRows)? i + xOffset : i - xOffset;
  matrixPoint.y = (matrixCols > gridCols)? j + yOffset : j - yOffset;
  
  return matrixPoint;
}

void mouseReleased()
{
  if (mouseX < x - sizeCP5Group)
  {
    if (currentSettings.getTransformer() != null && !draggingOn)
    {
      /* if there is a transformer there's a pattern too */
      PVector currentTransformPoint =
        currentSettings.getTransformer().convertCoordinates(mouseX, mouseY);
      /* get point inside the grid */
      PVector pointInGrid =
        currentGrid.getPointForCoordinates(currentTransformPoint);
      /* right click decrement the status, left one increments it */
      if(pointInGrid != null)
      {
        PVector pointInMatrix = getPointInMatrix(pointInGrid,
                                                 currentGrid,
                                                 currentConfig);
        int mi = (int)pointInMatrix.x;
        int mj = (int)pointInMatrix.y;
        int currentState = currentConfig.getCellState(mi, mj);
        if(mouseButton == RIGHT)
        {
          
          println("RIGHT mouse button, decrementing status", currentState);
          currentConfig.decrementState(mi, mj);
        }
        else if (mouseButton == LEFT)
        {
          println("LEFT mouse button, incrementing status", currentState);
          if (currentConfig.getCellState(mi, mj) < paletteColors)
            currentConfig.incrementState(mi, mj);
        }
      }
      
      transformer.resetMousePosition();
    }
  }  
}

void mouseDragged()
{
  if (currentSettings.getTransformer() != null && !popupOn)
  {
    draggingOn = true;
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
  if (checkKey(KeyEvent.VK_META) && checkKey(KeyEvent.VK_V))
  {
    pastedMessage = GetTextFromClipboard();
    loadGollyRle();
  }
}

void keyReleased()
{ 
  keys[keyCode] = false;
}

void dropEvent(DropEvent theDropEvent) {
  if(theDropEvent.isFile()) {
    // for further information see
    // http://java.sun.com/j2se/1.4.2/docs/api/java/io/File.html
    File myFile = theDropEvent.file();
    println("\nisDirectory ? " + myFile.isDirectory() + "  /  isFile ? " + myFile.isFile());
    if (myFile.isDirectory()) {
      showPopup("Hai draggato una directory intera, esagerato!" +
                "\n\nDragga un RLE per volta, thanks :D", 0, -1);
    } else {
      gollyFilePath = myFile.getAbsolutePath();
      loadGollyRle();
    }
  }
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


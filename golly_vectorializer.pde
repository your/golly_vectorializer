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
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;



/* Mains */

GollyRleReader reader;
GollyFileSaver rleSaver; // We could have created a GollyRleSaver..
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;

SketchTransformer currentTransformer;
Grid2D currentGrid;
ControlP5 cp5;
CDrawable[] d;
SDrop drop;
Group mainG, fileG, gridG, settG, lockG, winG, caG;

String gollyFilePath = null;
String pastedMessage;
String pdfFile;

int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int popupXSize, popupYSize = 0;
int paletteColors = 7;

// empty sketch parameters
int defaultPatternHeight = 65;
int defaultPatternWidth = 65;

float cellDim = 8.50f;
float scaleUnit = 0.05;
float pdfBorder = 5.0;

color bg = color(255);
color cp = color(10, 20, 10, 200);
color cq = color(200, 180, 200, 100);

boolean popupOn = false;
boolean draggingOn = false;
boolean[] keys = new boolean[526];

//==========================================================



/* Spinning wheel vars */

float[] arcStartPositions = new float[3];
float arcBoundSize, arcMaxBoundSize = 80;

boolean loadingSomething = false;

//==========================================================


/* Application Updater vars */

CodeSource codeSource;
ApplicationUpdater updater;

int remotePort = 3300;

String remoteHost = "mm.sharped.net";
String remoteScript = "cgi-bum/mmupdate.icg";
String remotePath = "cgi-bum/release/golly_vectorializer.app/Contents/Java/";

//==========================================================



/* Setup Area */

void setup()
{   
  /* Setting up main display settings */
  size(x, y);
  background(bg);
  smooth();
  
  /* capping the frame rate, shall we go even lower? */
  frameRate(27);

  /* drag&drop */
  drop = new SDrop(this);

  /* serializer */
  serializationManager = new SerializationManager();

  /* palette stuff */
  d = new CDrawable[paletteColors + 1]; // add a position for inactive states too

  /* init ApplicationUpdater */
  codeSource = golly_vectorializer.class.getProtectionDomain().getCodeSource();
  updater = new ApplicationUpdater(remoteHost, remotePort,
                                   remoteScript, remotePath, codeSource);

  /* Global objects init */
  manager = new GollyHistoryManager();
  reader = new GollyRleReader();
  rleSaver = new GollyFileSaver();
  currentSettings = new GollyPatternSettings();
  currentGrid = new Grid2D();
  currentTransformer = null;

  /* Building CP5 objects */
  cp5 = new ControlP5(this);
  // MAIN CONTROLS
  // MAIN GROUP AREA
  mainG = cp5.addGroup("mainControls")
    .setPosition(width-sizeCP5Group, 0)
    .setSize(sizeCP5Group, height)
    ;
    
  // FILE AREA
  fileG = cp5.addGroup("fileControls")
    .setPosition(10, 20)
    .setSize(180, 90)
    .setBackgroundColor(color(102, 102, 102))
    .setLabel("MAINS").setColorBackground(color(10, 0, 10, 200))
    .moveTo(mainG)
    ;
    
  // LOAD RLE AREA
  cp5.addButton("loadRleConfig")
    .setLabel("Add Golly RLE").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 10)
    .setSize(105, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
    
  cp5.addButton("newEmptyConfig")
    .setLabel("New void pattern").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 26)
    .setSize(105, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
  
  cp5.addButton("exportToPDF").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setLabel("Export to PDF")
    .setPosition(115, 10)
    .setSize(60, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
  
  cp5.addButton("exportToRLE")
    .setLabel("Export to RLE").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(115, 26)
    .setSize(60, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
  
  cp5.addButton("info")
    .setLabel("?").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 65)
    .setSize(15, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
  
  cp5.addButton("checkForUpdate")
    .setLabel("Check for updates").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(25, 65)
    .setSize(150, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;

  cp5.addButton("serialize")
    .setLabel("Save Config..").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 45)
    .setSize(80, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;
  
  cp5.addButton("deserialize")
    .setLabel("Load Config..").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(95, 45)
    .setSize(80, 15)
    .setColorBackground(cp)
    .moveTo(fileG)
    ;

 // GRID SUBGROUP AREA
  gridG = cp5.addGroup("gridControls")
    .setPosition(10, 130)
    .setSize(180, 250)
    .setBackgroundColor(color(1, 108, 158))
    .setLabel("Grid Settings").setColorBackground(color(10, 0, 10, 200))
    .moveTo(mainG)
    ;
    
  cp5.addTextlabel("resizeGrid")
    .setPosition(5, 10)
    .setText("GRID SIZE")
    .moveTo(gridG)
    ;
    
  cp5.addSlider("rowsNum")
    .setLabel("ROWS")
    .setPosition(5, 25)
    .setSize(145, 10)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .setValue(currentGrid.getRows())
    .moveTo(gridG)
    ;
    
  cp5.addSlider("colsNum")
    .setLabel("COLS")
    .setPosition(5, 36)
    .setSize(145, 10)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .setValue(currentGrid.getColumns())
    .moveTo(gridG)
    ;
    
  cp5.addTextlabel("resizeCells")
    .setPosition(5, 60)
    .setText("CELLS SIZE")
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
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
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
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .setValue(currentGrid.getCellHeight())
    .setRange(0, 200)
    .moveTo(gridG)
    ;
    
  cp5.addToggle("toggleKeepCellRatio")
    .setLabel("Keep ratio")
    .setPosition(5, 98)
    .setSize(42, 15)
    .setValue(currentSettings.getKeepCellRatio())
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
    
  cp5.addToggle("toggleShowGrid")
    .setLabel("Draw Grid")
    .setPosition(5, 210)
    .setSize(42, 15)
    .setValue(currentSettings.getShowGrid())
    .setMode(ControlP5.SWITCH)
    .moveTo(gridG)
    ;
    
  cp5.addToggle("toggleShowInactives")
    .setLabel("Draw inactive cells")
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
    .setLabel("Center me!").align(0, 0, ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 183)
    .setSize(55, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
    
  cp5.addButton("scaleMe")
    .setLabel("Scale me!").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(75, 183)
    .setSize(55, 15)
    .setColorBackground(cp)
    .moveTo(gridG)
    ;
    
  // SETTINGS SUBGROUP AREA
  settG = cp5.addGroup("settControls")
    .setPosition(10, 395)
    .setSize(180, 340)
    .setBackgroundColor(color(1, 108, 158))
    .setLabel("Pattern Settings").setColorBackground(color(10, 0, 10, 200))
    .moveTo(mainG)
    ;
    
  // SHAPES AREA
  cp5.addTextlabel("resizeShapes")
    .setPosition(5, 10)
    .setText("ACTIVE SHAPES SIZE")
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
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
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
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .setRange(0, 200)
    .moveTo(settG)
    ;
    
  cp5.addToggle("toggleKeepShapeRatio")
    .setLabel("Keep Ratio")
    .setPosition(5, 48)
    .setSize(42, 15)
    .setBroadcast(false)
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
    
  cp5.addToggle("toggleShapesLikeCells")
    .setLabel("Copy cells size")
    .setPosition(85, 48)
    .setSize(63, 15)
    .setBroadcast(false)
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
    
   cp5.addTextlabel("modeLabel")
     .setPosition(5, 90)
     .setText("FILLING MODE")
     .moveTo(settG)
     ;
     
  cp5.addRadioButton("modeRadio")
    .setPosition(5,105)
    .setSize(20,20)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(2)
    .setSpacingColumn(47)
    .setGroup(settG)
    .addItem("Standard",1)
    .addItem("Random",2)
    .addItem("RL",3)
    ;
    
  cp5.addSlider("randomRadius")
    .setLabel("Radius")
    .setPosition(50, 130)
    .setSize(90, 12)
    .setRange(0, 20)
    .setSliderMode(Slider.FLEXIBLE)
    .setColorForeground(color(240,0,0))
    .moveTo(settG)
    ;
    
  cp5.addButton("openPalette")
    .setLabel("OPEN PALETTE").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(5, 155)
    .setSize(90, 25)
    .setColorBackground(cp)
    .moveTo(settG)
    ;
    
  cp5.addButton("shuffleColors")
    .setLabel("Shuffle!").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    .setPosition(110, 155)
    .setSize(60, 25)
    .setColorBackground(cp)
    .moveTo(settG)
    ;
    
  cp5.addToggle("toggleWorkingStates")
    .setLabel("Active states settings")
    .setPosition(40, 300)
    .setSize(100, 15)
    .setBroadcast(false) // needed as explained above
    .setValue(currentSettings.workingOnActiveStates()) // def
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
    
  cp5.addToggle("toggleFill")
    .setLabel("Fill ON")
    .setPosition(100, 255)
    .setSize(42, 15)
    .setValue(currentSettings.isFillOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;
    
  cp5.addTextlabel("pickerStrokeLabel")
    .setPosition(5, 195)
    .setText("ACTIVE CELLS STROKE")
    .moveTo(settG)
    ;
    
  cp5.addSlider("pickRStroke")
    .setLabel("R")
    .setPosition(5, 210)
    .setSize(160, 10)
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
    
  cp5.addSlider("pickGStroke")
    .setLabel("G")
    .setPosition(5, 221)
    .setSize(160, 10)
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
    
  cp5.addSlider("pickBStroke")
    .setLabel("B")
    .setPosition(5, 232)
    .setSize(160, 10)
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
    
  cp5.addSlider("pickAStroke")
    .setLabel("A")
    .setPosition(5, 243)
    .setSize(160, 10)
    .setColorForeground(color(255, 255, 255))
    .setRange(0, 255)
    .moveTo(settG)
    ;
    
  cp5.addToggle("toggleStroke")
    .setLabel("Stroke ON")
    .setPosition(5, 255)
    .setSize(42, 15)
    .setValue(currentSettings.isStrokeOnActive())
    .setMode(ControlP5.SWITCH)
    .moveTo(settG)
    ;

  // CA group
  caG = cp5.addGroup("caGroup")
    .setPosition(10, 10)
    .setSize(200, 30)
    .setBackgroundColor(color(200,180,200,50))
    .hideBar()
    ;
    
  cp5.addButton("removeConfig")
    .setLabel("X")
    .setPosition(5, 9)
    .setSize(12,12)
    .setGroup(caG)
    ;
    
  cp5.addTextarea("nameConfig")
    .setPosition(20,10)
    .setSize(200,15)
    .setColor(0)
    .hideScrollbar()
    .setGroup(caG)
    ;
  
  // LOCK GROUP
  lockG = cp5.addGroup("lockBox")
    .setSize(width, height)
    .setPosition(0, 0)
    .setBackgroundColor(color(10, 0, 10, 200))
    .hide()
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
    .setValue("Previews:")
    .setPosition(30,60)
    .setSize(10,10)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextlabel("labelPaletteProb")
    .setValue("Probability %:")
    .setPosition(190,60)
    .setSize(20,10)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor1")
    .setLabel("State 1")
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
    
  cp5.addTextfield("inputPaletteProb1")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,80)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor2")
    .setLabel("State 2")
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
    
  cp5.addTextfield("inputPaletteProb2")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,120)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor3")
    .setLabel("State 3")
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
    
  cp5.addTextfield("inputPaletteProb3")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,160)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor4")
    .setLabel("State 4")
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
    
  cp5.addTextfield("inputPaletteProb4")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,200)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor5")
    .setLabel("State 5")
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
    
  cp5.addTextfield("inputPaletteProb5")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,240)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor6")
    .setLabel("State 6")
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
    
  cp5.addTextfield("inputPaletteProb6")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,280)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColor7")
    .setLabel("State 7")
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
    
  cp5.addTextfield("inputPaletteProb7")
    .setLabel("")
    .setInputFilter(ControlP5.FLOAT)
    .setPosition(200,320)
    .setSize(40,13)
    .setColorBackground(0)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(winG)
    .hide()
    ;
    
  cp5.addTextfield("inputPaletteColorVoid")
    .setLabel("State 0 (INACTIVE)")
    .setPosition(100,360)
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
    .setLabel("Cancel").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Overwrite").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;
    
  cp5.addButton("buttonConfigRemovalOK")
    .setPosition(60,80)
    .setSize(75,25)
    .moveTo(winG)
    .setColorBackground(color(5))
    .setColorActive(color(20))
    .setBroadcast(false)
    .setValue(1)
    .setBroadcast(true)
    .setLabel("Delete!").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Download").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Restart now!").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Restart later").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Save").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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
    .setLabel("Cancel").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
    ;

  /* ca name is shown only if file has been loaded */
  caG.hide();
  
  /* Message box is shown only upon request */
  winG.hide();

  /* Lock controls @startup */
  manageControls(true);

  /* test if any update downloaded has to be applied */
  updateReady(false); // true to enable startup updates

  addFocusListener();
 
}

//==========================================================



/* Focus Listener */

void addFocusListener()
{
  this.addFocusListener(new FocusAdapter(){
    public void focusGained(FocusEvent e)
    {
      /* looping again */
      println("focus gained");
      loop();
    }
    public void focusLost(FocusEvent e)
    {
      /* lost focus, stop looping */
      println("focus lost");
      noLoop();
    }
  });
}

//==========================================================



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

//==========================================================



/* Serialization manager */

SerializationManager serializationManager;

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
  setLock(cp5.getController("scaleMe"), lock);
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
  setLock(cp5.getController("toggleFill"), lock);
  setLock(cp5.getController("pickRStroke"), lock);
  setLock(cp5.getController("pickGStroke"), lock);
  setLock(cp5.getController("pickBStroke"), lock);
  setLock(cp5.getController("pickAStroke"), lock);
  setLock(cp5.getController("toggleStroke"), lock);
  setLock(cp5.getController("toggleWorkingStates"), lock);
  setLock(cp5.getController("Standard"), lock);
  setLock(cp5.getController("Random"), lock);
  setLock(cp5.getController("RL"), lock);
  setLock(cp5.getController("randomRadius"), lock);
  setLock(cp5.getController("shuffleColors"), lock);
  
  if (!lock)
  {
    /* Colouring sliders if unlocked */
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

    // enabling default filling mode
    RadioButton r = (RadioButton)cp5.getGroup("modeRadio");
    r.activate(0);

    // showing ca name
    caG.show();
    updateCAName();

    // setting grid size sliders max range values
    updateGridSlidersRange();
  }
}

//==========================================================



/* Controls Handling */

void updateGridSlidersRange() {
  Slider s1 = (Slider)cp5.getController("rowsNum");
  Slider s2 = (Slider)cp5.getController("colsNum");
  s1.setBroadcast(false);
  s2.setBroadcast(false);
  s1.setRange(0, currentConfig.getMatrixHeight());
  s2.setRange(0, currentConfig.getMatrixWidth());
  s1.setBroadcast(true);
  s2.setBroadcast(true);
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
  cp5.getController("randomRadius").setBroadcast(false);
  // doing stuff on controls
  cp5.getController("rowsNum").setValue(currentGrid.getRows());
  cp5.getController("colsNum").setValue(currentGrid.getColumns());
  updateGridSlidersRange(); // update ranges too
  cp5.getController("cellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("cellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("inputCellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("inputCellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("toggleKeepCellRatio").setValue(currentSettings.getKeepCellRatio() ? 1 : 0);
  cp5.getController("toggleShowGrid").setValue(currentSettings.getShowGrid()?1:0);
  cp5.getController("toggleShowInactives").setValue(currentSettings.getShowInactives() ? 1 : 0);
  cp5.getController("zoomSlider").setValue(currentTransformer.getScaleFactor() * 100);
  cp5.getController("zoomPercentage").setStringValue((int)(currentTransformer.getScaleFactor() * 100) + "%");
  cp5.getController("randomRadius").setValue(currentSettings.getWindowRadius());
  // broadcasting values again
  cp5.getController("rowsNum").setBroadcast(true);
  cp5.getController("colsNum").setBroadcast(true);
  cp5.getController("toggleKeepCellRatio").setBroadcast(true);
  cp5.getController("toggleShowGrid").setBroadcast(true);
  cp5.getController("toggleShowInactives").setBroadcast(true);
  cp5.getController("zoomSlider").setBroadcast(true);
  cp5.getController("randomRadius").setBroadcast(true);

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

  // updating coloring mode
  updateColorMode();

}

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
  String status = flag? "ACTIV" : "INACTIV";
  mainG.getController("toggleWorkingStates").setLabel(
    status + "E " + "STATES SETTINGS");
  mainG.getController("resizeShapes").setStringValue(
    status + "E " + "SHAPES SIZE");
  // mainG.getController("pickerFillLabel").setStringValue(
  //   "RIEMPIMENTO FORME " + status + "E");
  mainG.getController("pickerStrokeLabel").setStringValue(
    status + "E " + "SHAPES STROKE");
  updateControls();
}

//==========================================================



/* CP5 objects callbacks */

void rowsNum(int val)
{
  currentGrid.setRows(val);
  if (currentTransformer != null)
    centerSketch();
}

void colsNum(int val)
{
  currentGrid.setColumns(val);
  if (currentTransformer != null)
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

  if (currentSettings.workingOnActiveStates())
    currentSettings.setShapesLikeCellsActive(flag);
  else
    currentSettings.setShapesLikeCellsInactive(flag);

  updateControls();
}

void toggleStroke(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleStroke").setLabel("Stroke " + status);
  if (currentSettings.workingOnActiveStates())
    currentSettings.setIsStrokeOnActive(flag);
  else
    currentSettings.setIsStrokeOnInactive(flag);
}

void toggleFill(boolean flag)
{
  String status = flag? "ON" : "OFF";
  mainG.getController("toggleFill").setLabel("Fill " + status);
  if (currentSettings.workingOnActiveStates())
    currentSettings.setIsFillOnActive(flag);
  else
    currentSettings.setIsFillOnInactive(flag);
}

void buttonOverwriteOK(boolean flag)
{
  /* FIXME: now it can either export a PDF or an RLE */
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
    .setLabel("Restart and update").align(0,0,ControlP5.CENTER, ControlP5.CENTER)
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

void updateZoomPercentage()
{
  float scaleFactor = currentTransformer.getScaleFactor();
  int percentage = ceil(100 * scaleFactor);
  mainG.getController("zoomPercentage").setStringValue(percentage + "%");
  updateControls();
}

void zoomSlider(int value)
{
  float scaleFactor = (float)value / 100; 
  //scaleFactor += scaleUnit;
  if (currentTransformer != null)
  {
    currentTransformer.setScaleFactor(scaleFactor);
    centerSketch();
    updateZoomPercentage();
  }
  //updateControls();
}

void zoomIn(int status)
{
  float scaleFactor = currentTransformer.getScaleFactor();
  scaleFactor += scaleUnit;
  currentTransformer.setScaleFactor(scaleFactor);
  centerSketch();
  updateZoomPercentage();
}

void zoomOut(int status)
{
  float scaleFactor = currentTransformer.getScaleFactor();
  if (scaleFactor > scaleUnit) 
    scaleFactor -= scaleUnit;
  currentTransformer.setScaleFactor(scaleFactor);
  centerSketch();
  updateZoomPercentage();
}

void scaleMe(int value)
{
  if(currentConfig != null)
  {
    int currentScale = currentSettings.getScaleFactor(); // saving orig scale
    GollyRleConfiguration x2Config = currentConfig.newScaledConfiguration(2);
    currentConfig = x2Config;
    /* Init new pattern configuration */
    initNewPatternFrom(currentConfig);
    /* da shit */
    currentSettings.setScaleFactor(currentScale * 2); // updating scale
    updateControls();
    updateCAName();
  }
}

//==========================================================



/* Palette Stuff */

void updateColorMode() {
  ColorMode actualColorMode = currentSettings.getColorMode();
  RadioButton r = (RadioButton)cp5.getGroup("modeRadio");
  switch(actualColorMode) {
  case NORMAL:
    r.activate(0);
    modeRadio(1);
    break;
  case RANDOM:
    r.activate(1);
    modeRadio(2);
    break;
  case RANDOM_LOCAL:
    r.activate(2);
    modeRadio(3);
    break;
  }
}

void modeRadio(int value) {
  switch(value) {
  case -1:
    /* workaround to keep the button enabled */
    RadioButton r = (RadioButton)cp5.getGroup("modeRadio");
    switch(currentSettings.getColorMode()) {
    case NORMAL:
      r.activate(0);
      break;
    case RANDOM:
      r.activate(1);
      break;
    case RANDOM_LOCAL:
      r.activate(2);
      break;
    }
    break;
  default:
  case 1:
    currentSettings.setColorMode(ColorMode.NORMAL);
    setLock(cp5.getController("shuffleColors"), true);
    setLock(cp5.getController("randomRadius"), true);
    break;
  case 2:
    currentSettings.setColorMode(ColorMode.RANDOM);
    setLock(cp5.getController("shuffleColors"), false);
    setLock(cp5.getController("randomRadius"), true);
    break;
  case 3:
    currentSettings.setColorMode(ColorMode.RANDOM_LOCAL);
    setLock(cp5.getController("shuffleColors"), false);
    setLock(cp5.getController("randomRadius"), false);
    break;
  }
}
void randomRadius(int val) {
  currentSettings.setWindowRadius(val);
}
void shuffleColors(int val) {
  if (currentSettings.getColorMode() == ColorMode.RANDOM)
    currentSettings.shuffleColorAssignment();
  else if (currentSettings.getColorMode() == ColorMode.RANDOM_LOCAL)
    currentSettings.shuffleRLColorAssignment();
}
void setDefaultPaletteColors(GollyPatternSettings settings)
{
  /* setting just the first three colors */
  // color rc = color(23, 123, 123);
  // color gc = color(180, 45, 11);
  // color bc = color(123, 100, 89);
  // color tc = color(34, 55, 89);
  // color zc = color(222, 90, 111);
  // color mc = color(4, 34, 230);
  // color hc = color(114, 73, 2);
  color rc = #ED2627;
  color gc = #FFC716;
  color bc = #ACCD36;
  color tc = #1A84C6;
  color zc = #2C348D;
  color mc = #F9ED2B;
  color hc = #F05A27;
  
  settings.setColor(0, rc);
  settings.setColor(1, gc);
  settings.setColor(2, bc);
  settings.setColor(3, tc);
  settings.setColor(4, zc);
  settings.setColor(5, mc);
  settings.setColor(6, hc);
}

void inputPaletteColor1(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor1"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(0);
}

void inputPaletteProb1(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb1"));
  txt.setValue(val);
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

void inputPaletteProb2(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb2"));
  txt.setValue(val);
}

void inputPaletteColor3(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor3"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(2);
}

void inputPaletteProb3(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb3"));
  txt.setValue(val);
}

void inputPaletteColor4(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor4"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(3);
}

void inputPaletteProb4(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb4"));
  txt.setValue(val);
}

void inputPaletteColor5(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor5"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(4);
}

void inputPaletteProb5(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb5"));
  txt.setValue(val);
}

void inputPaletteColor6(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor6"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(5);
}

void inputPaletteProb6(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb6"));
  txt.setValue(val);
}

void inputPaletteColor7(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColor7"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(6);
}

void inputPaletteProb7(String val) {
  val = val.replace(',', '.');
  Textfield txt = ((Textfield)cp5.getController("inputPaletteProb7"));
  txt.setValue(val);
}

void inputPaletteColorVoid(String val) {
  val = sanitizeHexInput(val);
  Textfield txt = ((Textfield)cp5.getController("inputPaletteColorVoid"));
  txt.setValue(val);
  color newColor = getColorFromHex(val);
  updatePaletteDrawable(-1);
}

void updatePaletteDrawable(int number) {
  String currentInput = number == -1 ?
    "inputPaletteColorVoid" :
    "inputPaletteColor" + (number + 1);
  String stringColor = cp5.getController(currentInput).getStringValue();
  color newColor = getColorFromHex(stringColor);
  int index = number == -1 ? d.length - 1 : number;
  winG.remove(d[index]);
  setDrawable(index, 50, 80 + (40 * index), 10, 10, newColor);
  winG.addDrawable(d[index]);
}

void saveProbabilities()
{
  double[] paletteDistribution = new double[paletteColors];
  
  for (int i = 0; i < paletteColors; i++)
  {
    String currentInput = "inputPaletteProb" + (i + 1);
    Textfield content = ((Textfield)cp5.getController(currentInput));
    double prob = Double.parseDouble(content.getText()) / 100;
    println(prob);
    paletteDistribution[i] = prob;
  }
  currentSettings.setColorProbability(paletteDistribution);
}

void savePalette() {
  saveProbabilities();
  for (int i = 0; i < paletteColors; i++) {
    String currentInput = "inputPaletteColor" + (i + 1);
    Textfield content = ((Textfield)cp5.getController(currentInput));
    String stringColor = content.getText(); //cp5.getController(currentInput).getStringValue();
    color newColor = getColorFromHex(stringColor);
    currentSettings.setColor(i, newColor);
  }
  // saving inactive color too
  Textfield content = ((Textfield)cp5.getController("inputPaletteColorVoid"));
  String inactiveColor = content.getText();
  color newColor = getColorFromHex(inactiveColor);
  currentSettings.setFillRInactive((int)red(newColor));
  currentSettings.setFillGInactive((int)green(newColor));
  currentSettings.setFillBInactive((int)blue(newColor));
  currentSettings.setFillAInactive((int)alpha(newColor));
}

void openPalette(int value) {
  showPopup("Put the hexadecimal values for each state:\n(press RETURN after EACH insertion!)", 300, 450, 4, 2);
  showPalette();
}

void showProbabilities() {
  winG.controller("labelPaletteProb").show();
  for (int i = 0; i < paletteColors; i++) {
    String currentInput = "inputPaletteProb" + (i + 1);
    winG.controller(currentInput).show();
    winG.controller(currentInput).setBroadcast(true);
    Textfield txt = ((Textfield)cp5.getController(currentInput));
    double prob = currentSettings.getColorProbability(i) * 100;
    String probString = String.format("%.2f", prob);
    txt.setText(probString.replace(",", "."));
    winG.controller(currentInput).setBroadcast(false);
  }
}

void showPalette() {
  showProbabilities();
  winG.controller("labelPalettePreview").show();
  for (int i = 0; i < paletteColors; i++) {
    String currentInput = "inputPaletteColor" + (i + 1);
    Textfield content = ((Textfield)cp5.getController(currentInput));
    String hexedColor = hex(currentSettings.getColor(i));
    content.setBroadcast(false);
    content.setValue(hexedColor.substring(2));
    content.setBroadcast(true);
    winG.controller(currentInput).show();
  }

  // inactive states part
  color colorInactive = color(currentSettings.getFillRInactive(),
                              currentSettings.getFillGInactive(),
                              currentSettings.getFillBInactive(),
                              currentSettings.getFillAInactive());
  Textfield content = (Textfield)cp5.getController("inputPaletteColorVoid");
  content.setBroadcast(false);
  content.setValue(hex(colorInactive).substring(2));
  content.setBroadcast(true);
  winG.controller("inputPaletteColorVoid").show();
  
  setDrawable(0, 50, 80, 10, 10, currentSettings.getColor(0));
  setDrawable(1, 50, 120, 10, 10, currentSettings.getColor(1));
  setDrawable(2, 50, 160, 10, 10, currentSettings.getColor(2));
  setDrawable(3, 50, 200, 10, 10, currentSettings.getColor(3));
  setDrawable(4, 50, 240, 10, 10, currentSettings.getColor(4));
  setDrawable(5, 50, 280, 10, 10, currentSettings.getColor(5));
  setDrawable(6, 50, 320, 10, 10, currentSettings.getColor(6));
  setDrawable(7, 50, 360, 10, 10, colorInactive);
  winG.addDrawable(d[0]);
  winG.addDrawable(d[1]);
  winG.addDrawable(d[2]);
  winG.addDrawable(d[3]);
  winG.addDrawable(d[4]);
  winG.addDrawable(d[5]);
  winG.addDrawable(d[6]);
  winG.addDrawable(d[7]);
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
  winG.remove(d[7]);
  winG.controller("labelPalettePreview").hide();
  winG.controller("inputPaletteColor1").hide();
  winG.controller("inputPaletteColor2").hide();
  winG.controller("inputPaletteColor3").hide();
  winG.controller("inputPaletteColor4").hide();
  winG.controller("inputPaletteColor5").hide();
  winG.controller("inputPaletteColor6").hide();
  winG.controller("inputPaletteColor7").hide();
  winG.controller("inputPaletteColorVoid").hide();
  winG.controller("labelPaletteProb").show();
  winG.controller("inputPaletteProb1").hide();
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

//==========================================================



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

//==========================================================



/* Serializer/config stuff */

void serialize()
{
  File defaultFile = createDefaultFile();
  if(defaultFile == null)
  {
    defaultFile = new File("Untitled");
  }
  selectOutput("Select destination:", "serializeConfigAndSettings", defaultFile);
}

void deserialize()
{
  selectInput("Select source:", "deserializeConfigAndSettings");
}

void serializeConfigAndSettings(File selected)
{
  if(selected != null)
  {
    String path = selected.getAbsolutePath();
    println("Serializing file", path);

    try {
      serializationManager.serializeConfigurationAndSettings(currentConfig,
                                                             currentSettings,
                                                             path);
    } catch(IOException e) {
      showPopup("An error occurred while saving the configuration!\n\n", 0, -1);
      e.printStackTrace();
    }
  }
}

void deserializeConfigAndSettings(File selected)
{
  if(selected != null)
  {
    String path = selected.getAbsolutePath();
    println("Deserializing file", path);

    try {
      Map<String, Object> deserializedObjects =
        (HashMap<String, Object>) serializationManager.deserializeConfigurationAndSettings(path);
    
      GollyRleConfiguration loadedConfig = (GollyRleConfiguration) deserializedObjects.get("config");
      GollyPatternSettings loadedSettings = (GollyPatternSettings) deserializedObjects.get("settings");

      /* Init current configuration */
      initConfiguration(loadedConfig);
      initSettings(loadedConfig, loadedSettings);
    
      initTransformer();

      updateHistory();
      manageControls(false);

      /* update controls */
      updateControls();
      
    } catch(IOException e) {
      showPopup("An error occurred while loading the configuration!" +
                "\n\n(Wrong file format?)", 0, -1);
      e.printStackTrace();
    } catch(ClassNotFoundException e) {
      showPopup("An error occurred while loading the configuration!" +
                "\n\n(Wrong file format or from ad old version?)", 0, -1);
      e.printStackTrace();
    }
  }
}

void removeConfig() {
  showPopup("Do you relly want to delete this configuration?"
            + "\n\n(Unexported changes will be lost!)", 5, 0);
}

void buttonConfigRemovalOK() {
  boolean havePrev = manager.hasPrevConfig();
  boolean haveNext = manager.hasNextConfig();
  /* removing currents */
  if (haveNext || havePrev) {
    setLock(caG.getController("removeConfig"), false);
    manager.removeCurrentConfiguration();
    manager.removeCurrentGrid();
    manager.removeCurrentSettings();
    manager.removeCurrentTransformer();
    /* updating currents & stuff */
    updateHistory();
    updateCAName();
    updateControls();
  } else
    setLock(caG.getController("removeConfig"), true);
  killPopup();
}

//==========================================================



/* Popup stuff */

void resetPopup() {
  // reset buttons
  winG.controller("buttonGenericOK").hide();
  winG.controller("buttonOverwriteOK").hide();
  winG.controller("buttonDownloadUpdateOK").hide();
  winG.controller("buttonApplyUpdateOK").hide();
  winG.controller("buttonConfigRemovalOK").hide();
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
    popupYSize = lines * 40 + 20;
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
  // 5: configRemovalOK

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
    break;
  case 5:
    cp5.controller("buttonConfigRemovalOK").setPosition(popupXSize / 2 - 100,
                                                        popupYSize - 45);
    cp5.controller("buttonConfigRemovalOK").show();
    break;
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
    break;
  }
  
  winG.show();
  //popupOn = true;
  
  // resetting those
  popupXSize = 0;
  popupYSize = 0;
}

void killPopup()
{
  winG.getController("messageBoxLabel").remove();
  winG.hide();
  lockG.hide();
  //popupOn = false;
}

//==========================================================



/* File I/O Stuff */

void loadRleConfig(int status)
{
  selectInput("Selece a Golly RLE File:", "fileSelected");
}

void newEmptyConfig(int status)
{
  newGollyPattern();
}

void exportToPDF(int status)
{
  File defaultFile = createDefaultFile();
  if(defaultFile == null)
  {
    defaultFile = new File("Untitled");
  }
  selectOutput("Select PDF destination:", "pdfSelected", defaultFile);
}

void exportToRLE(int status)
{
  File defaultFile = createDefaultFile();
  if(defaultFile == null)
  {
    defaultFile = new File("Untitled");
  }
  selectOutput("Select RLE destination:", "rleSelected", defaultFile);
}

boolean fileExists(String filename) {

  File file = new File(filename);

  if (!file.exists())
    return false;

  return true;
}

File createDefaultFile()
{
  File defaultFile = null;
  
  /* an rle file has been selected */
  String currentRlePath = currentSettings.getRleFilePath();
  if(currentRlePath != null)
  {
    //println("Current path ", currentRlePath);
    /* get the filename */
    int index = currentRlePath.lastIndexOf(File.separator);
    
    String filename = currentRlePath.substring(index + 1);
    //println("Current filename", filename);
    /* removing the extension */
    index = filename.lastIndexOf(".rle");
    String rawName = filename.substring(0, index);
    //println("Current rawname ", rawName);
    
    defaultFile = new File(rawName);
  }
    
  return defaultFile;
}

/* Processing file selection callback */

void fileSelected(File selection)
{
  if (selection == null)
  {
    println("Window was closed or the user hit cancel.");
  } 
  else
  {
    gollyFilePath = selection.getAbsolutePath();
    println("User selected " + gollyFilePath);
    loadGollyRle();
  }
}
void pdfSelected(File selection)
{
  if (selection == null)
  {
    println("Window was closed or the user hit cancel.");
  }
  else
  {
    pdfFile = selection.getAbsolutePath() + ".pdf";
    println("User selected " + pdfFile);
    if (!fileExists(pdfFile)) exportNow();
    else showPopup("Destination PDF already exists!\n\nOverwrite it?", 1, 0);
  }
}

void rleSelected(File selection)
{
  if (selection == null)
  {
    println("Window was closed or the user hit cancel.");
  }
  else
  {
    String rleFile = selection.getAbsolutePath() + ".rle";
    println("User selected " + rleFile);
    rleSaver.exportConfigurationToRle(currentConfig, rleFile);
  }
}

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
    
    /* Init pattern from current configuration */
    initNewPatternFrom(currentConfig);

    /* da shit */
    updateControls();
  }
  catch (RuntimeException e)
  {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
    showPopup("Please input a Golly RLE file!\n\n", 0, -1);
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

//==========================================================



/* History stuff */

void updateCAName() {
  String nameBase = "CA: ";
  String nameScale = currentSettings.getScaleFactor() > 1 ?
    "(SCALED X" + currentSettings.getScaleFactor() + ") " : "";
  String nameCA = createDefaultFile() != null ? createDefaultFile().toString() : "Untitled";
  Textarea txt = (Textarea)cp5.getGroup("nameConfig");
  txt.setText(nameBase + nameScale + nameCA);
  
  int newLength = (nameBase.length() + nameScale.length() + nameCA.length()) * 6 + 20;
  txt.setWidth(newLength);
  caG.setWidth(newLength);
}

void forwardConfigHistory(int status)
{
  manager.forwardHistory();
  updateHistory();
  updateControls();
  updateCAName();
}

void rewindConfigHistory(int status)
{
  manager.rewindHistory();
  updateHistory();
  updateControls();
  updateCAName();
}

void updateHistory()
{
  currentGrid = manager.getCurrentGrid();
  currentConfig = manager.getCurrentConfiguration();
  currentSettings = manager.getCurrentSettings();
  currentTransformer = manager.getCurrentTransformer();
  checkConfigHistory();
}

void checkConfigHistory()
{
  /* Config history handling */
  boolean lockPrev = manager.hasPrevConfig();
  boolean lockNext = manager.hasNextConfig();
  setLock(mainG.getController("rewindConfigHistory"), !lockPrev);
  setLock(mainG.getController("forwardConfigHistory"), !lockNext);
  // force to keep at least one item
  setLock(caG.getController("removeConfig"), !lockNext ? !lockPrev : !lockNext);
}

//==========================================================



/* Drawing */

void draw()
{
  /* Refreshing bg */
  background(bg);
  
  if (loadingSomething)
    drawLoadingWheel(g);
  else
  {
  
    if (currentTransformer != null)
    {

      if (loadingSomething)
        drawLoadingWheel(g);
      else
      {
        /* getting ready for drawing */
        currentTransformer.startDrawing();
      
        /* are we ready to draw? */
        if (currentSettings.getShowGrid()) currentGrid.draw(g, color(204, 204, 204));
        drawGollyPattern(g, currentGrid, currentConfig, currentSettings);

        /* ended drawing */
        currentTransformer.endDrawing();
      }
    }
  }
}

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

         /* it is not a matter of the original cell state anymore */
         int currentState = config.getCellState(mi, mj);

         // boolean isActiveState = settings.isActiveState(mi, mj);
          if (currentState > 0) /* each state > 0 is considered active */
         // if(isActiveState)
         {
          // Setting PShape fill&stroke up
          if (settings.isFillOnActive())
          {
            //ctx.fill(colorFillActive);
            // ctx.fill(palette.getColor(currentState - 1));
            ctx.fill(settings.getColor(mi, mj));

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

//==========================================================



/* Init stuff */

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

void initSettings(GollyRleConfiguration configuration,
                  GollyPatternSettings settings) {
  settings.setRleFilePath(gollyFilePath);
  manager.addSettings(settings); // start pattern with defaults
}

void initNewPatternFrom(GollyRleConfiguration configuration) {
  
  /* Associating default settings to config */
  currentSettings = new GollyPatternSettings();
  /* initing a default palette */
  currentSettings.initColors(paletteColors, configuration);
  setDefaultPaletteColors(currentSettings);

  /* init config and settings */
  initConfiguration(configuration);
  initSettings(configuration, currentSettings);

  /* init standard transformer */
  initTransformer();
  
  /* Can we enable nextConfig button? */
  checkConfigHistory();

  /* Init GUI controls */
  manageControls(false);
}

void initConfiguration(GollyRleConfiguration configuration)
{
  /* Adding config history */
  manager.addConfiguration(configuration);

  /* Generating grid from it (then adding it to history) */
  currentGrid = generateGridFrom(configuration);
  /* Adding grid to history */
  manager.addGrid(currentGrid);
}

void initTransformer() {
  /* Init SketchTransformer */
  currentTransformer = new SketchTransformer((width - sizeCP5Group) / 2,
                                             height / 2,
                                             1.0);
  manager.addTransformer(currentTransformer);

  /* Centering sketch */
  centerSketch();
}

//==========================================================





/* creating an empty drawing prototyping area */
void newGollyPattern()
{
  /* empty verstion of initConfiguration with  a default grid */
  currentConfig =
    GollyRleConfiguration.newEmptyConfiguration(defaultPatternHeight,
                                                defaultPatternWidth);
  initNewPatternFrom(currentConfig);
  /* set UI accordingly */
  updateControls();
}

void checkForUpdate()
{
  try {
    if (updater.updateAvailable()) {
      showPopup("New update available!\n\nDownload it now?", 2, 0);
    } else {
      showPopup("No updates available!\n\n", 0, -1);
    }
  } catch(Exception e) {
    showPopup("Unable to check for new updates :(\n\n" +
              e.getMessage(), 0, -1);
  }
}



/* Update stuff */

void downloadUpdate()
{
  try {
    updater.downloadUpdate();
    if (updater.updateReady()) {
      showPopup("Update is ready!\nThis program needs to be restart to apply it.\n\n" +
                "Restart now? (if not, it will be applied at the next run)", 3, 1);
    }
  } catch(Exception e) {
    showPopup("Unable to download the update :(\n\n" +
              e.getMessage(), 0, -1);
  }
}

void applyUpdate()
{
  try {
    updater.applyUpdate();
    if (updater.updateSuccessfull()) {
      showPopup("Latest update applied successfully! :D\n\n", 0, -1);
    } else {
      showPopup("An error occurred while applying the update :O\n\n", 0, -1);
    }
  } catch(Exception e) {
    showPopup("An error occurred while applying the update :O\n\n" +
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

//==========================================================



/* Centering */

void center(int value)
{
  centerSketch();
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
  currentTransformer.centerSketch(width, sizeCP5Group, height, 0, patternWidth, patternHeight);
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


//==========================================================



/* Misc Helpers */

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

//==========================================================



/* Mouse/keyboard events */

void mousePressed()
{
  if (draggingOn)
    draggingOn = false;
    popupOn = lockG.isVisible(); // update this guy at each press
  if (mouseX < width - sizeCP5Group && mouseY < height - 60)
  {
    if (currentTransformer != null && !popupOn)
    { 
      currentTransformer.saveMousePosition(mouseX, mouseY);
    }
  }
}

void mouseReleased()
{
  if (mouseX < width - sizeCP5Group && mouseY < height - 60 && mouseY > 50)
  {
    if (currentTransformer != null && !popupOn && !draggingOn)
    {
      /* allowing drawing only in normal mode */
      if(currentSettings.getColorMode() == ColorMode.NORMAL)
      {
        /* if there is a transformer there's a pattern too */
        PVector currentTransformPoint =
          currentTransformer.convertCoordinates(mouseX, mouseY);
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
            /* update the real pattern and the color assignment as well  */
            currentConfig.decrementState(mi, mj);
            currentSettings.previousColorAssignment(mi, mj);

          }
          else if (mouseButton == LEFT)
          {
            println("LEFT mouse button, incrementing status", currentState);
            if (currentConfig.getCellState(mi, mj) < paletteColors)
            {
              currentConfig.incrementState(mi, mj);
            }
            currentSettings.nextColorAssignment(mi, mj);
          }
        }
      }
       
      currentTransformer.resetMousePosition();
    }
  }  
}

void mouseDragged()
{
  if (mouseX < width - sizeCP5Group)
  {
    if (currentTransformer != null && !popupOn)
    {
      draggingOn = true;
      currentTransformer.updateTranslationOffset(mouseX, mouseY);
    }
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
      showPopup("You dragged a whole directory!" +
                "\n\nDrag ONE RLE per time, thanks :D", 0, -1);
    } else {
      gollyFilePath = myFile.getAbsolutePath();
      loadGollyRle();
    }
  }
}

//==========================================================



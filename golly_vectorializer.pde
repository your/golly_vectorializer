import java.io.*;
import java.util.*;
import java.net.*;
import controlP5.*;
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
// ResizableColorPicker cp5e;
Group mainG, gridG, settG, lockG, winG;
String gollyFilePath;
String pastedMessage;
String pdfFile;
boolean[] keys = new boolean[526];

/* Default window/drawing settings */
int x = 1024;
int y = 768;
int sizeCP5Group = 200;
int cellDim = 10;
float scaleUnit = 0.05;
float pdfBorder = 5.0;
color bg = color(255);
color cp = color(10, 20, 10, 200);
color cq = color(200, 180, 200, 100);
// boolean keepRatio = true;
// boolean showGrid = true;
boolean initControls = false;
boolean lockedGrid = false;

/* Application Updater stuff */
ApplicationUpdater updater;
String remoteHost = "mm.sharped.net";
int remotePort = 3300;
String remoteScript = "cgi-bum/mmupdate.icg";
String remotePath = "cgi-bum/release/golly_vectorializer.app/Contents/Java/";

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
  setLock(cp5.getController("zoomIn"), lock);
  setLock(cp5.getController("zoomOut"), lock);
  setLock(cp5.getController("center"), lock);
  // settG
  setLock(cp5.getController("rowsNum"), lock); // temp disabled
  setLock(cp5.getController("colsNum"), lock); // temp disabled
  setLock(cp5.getController("shapeWidth"), lock);
  setLock(cp5.getController("shapeHeight"), lock);
  setLock(cp5.getController("inputShapeWidth"), lock);
  setLock(cp5.getController("inputShapeHeight"), lock);
  setLock(cp5.getController("toggleKeepShapeRatio"), lock);
  setLock(cp5.getController("toggleShapesLikeCells"), lock);
  setLock(cp5.getController("pickRFillActive"), lock);
  setLock(cp5.getController("pickGFillActive"), lock);
  setLock(cp5.getController("pickBFillActive"), lock);
  setLock(cp5.getController("pickAFillActive"), lock);
  setLock(cp5.getController("inputRFillActive"), lock);
  setLock(cp5.getController("inputGFillActive"), lock);
  setLock(cp5.getController("inputBFillActive"), lock);
  setLock(cp5.getController("inputAFillActive"), lock);
  setLock(cp5.getController("toggleFillActive"), lock);
  setLock(cp5.getController("pickRStrokeActive"), lock);
  setLock(cp5.getController("pickGStrokeActive"), lock);
  setLock(cp5.getController("pickBStrokeActive"), lock);
  setLock(cp5.getController("pickAStrokeActive"), lock);
  setLock(cp5.getController("toggleStrokeActive"), lock);
  if (!lock)
  {
    /* Colouring sliders if unlocked */
    cp5.getController("pickRFillActive").setColorBackground(color(200, 20, 40));
    cp5.getController("pickRStrokeActive").setColorBackground(color(200, 20, 40));
    cp5.getController("pickGFillActive").setColorBackground(color(20, 200, 40));
    cp5.getController("pickGStrokeActive").setColorBackground(color(20, 200, 40));
    cp5.getController("pickBFillActive").setColorBackground(color(40, 20, 200));
    cp5.getController("pickBStrokeActive").setColorBackground(color(40, 20, 200));
    cp5.getController("pickAFillActive").setColorBackground(color(100, 100, 100));
    cp5.getController("pickAStrokeActive").setColorBackground(color(100, 100, 100));
  }
}

void setup()
{   
  /* Setting up main display settings */
  smooth();
  frameRate(30);

  size(x, y);

  // /* setting up transformer */
  // transformer = new SketchTransformer((width-sizeCP5Group)/2, height/2, 1.0);

  background(bg);

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
      .setSize(180, 185)
        .setBackgroundColor(color(1, 108, 158))
          //.setBackgroundColor(color(20,0,20,150))
          //.setBackgroundColor(color(175,190,175,220))
          .setLabel("Impostazioni Griglia").setColorBackground(color(10, 0, 10, 200))
            .moveTo(mainG)
              ;
  cp5.addTextlabel("resizeGrid")
    .setPosition(5, 10)
      .setText("DIMENSIONE GRIGLIA (beta disabled)")
        .moveTo(gridG)
          ;
  cp5.addSlider("rowsNum")
    .setLabel("ROWS")
      .setPosition(5, 25)
        .setSize(145, 10)
          .setValue(currentGrid.getRows())
            .setRange(0, 200)
              .moveTo(gridG)
                ;
  cp5.addSlider("colsNum")
    .setLabel("COLS")
      .setPosition(5, 36)
        .setSize(145, 10)
          .setValue(currentGrid.getColumns())
            .setRange(0, 200)
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
    .setLabel("Keep Ratio")
      .setPosition(5, 98)
        .setSize(42, 15)
          .setValue(currentSettings.getKeepCellRatio())
            .setMode(ControlP5.SWITCH)
              .moveTo(gridG)
                ;
  cp5.addToggle("toggleShowGrid")
    .setLabel("Show Grid")
      .setPosition(5, 145)
        .setSize(42, 15)
          .setValue(currentSettings.getShowGrid())
            .setMode(ControlP5.SWITCH)
              .moveTo(gridG)
                ;
  cp5.addButton("zoomIn")
    .setLabel("Zoom +")
      .setPosition(70, 110)
        .setSize(35, 15)
          .setColorBackground(cp)
            .moveTo(gridG)
              ;
  cp5.addButton("zoomOut")
    .setLabel("Zoom -")
      .setPosition(110, 110)
        .setSize(35, 15)
          .setColorBackground(cp)
            .moveTo(gridG)
              ;
  cp5.addTextlabel("zoomPercentage")
    .setText("100%")
      .setPosition(150, 113)
        .setSize(35, 15)
          .moveTo(gridG)
            ;
  cp5.addButton("center")
    .setLabel("Centrami!").align(0, 0, ControlP5.CENTER, ControlP5.CENTER)
      .setPosition(70, 130)
        .setSize(75, 15)
          .setColorBackground(cp)
            .moveTo(gridG)
              ;
  // SETTINGS SUBGROUP AREA
  settG = cp5.addGroup("settControls")
    .setPosition(10, 335)
      .setSize(180, 320)
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
          .setValue(currentSettings.getShapeWidth())
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
          .setValue(currentSettings.getShapeHeight())
            .setRange(0, 200)
              .moveTo(settG)
                ;
  cp5.addToggle("toggleKeepShapeRatio")
    .setLabel("Keep Ratio")
      .setPosition(5, 48)
        .setSize(42, 15)
          .setValue(currentSettings.getKeepShapeRatio())
            .setMode(ControlP5.SWITCH)
              .moveTo(settG)
                ;
  cp5.addToggle("toggleShapesLikeCells")
    .setLabel("Copia Dim Celle")
      .setPosition(65, 48)
        .setSize(63, 15)
          .setValue(currentSettings.getShapesLikeCells())
            .setMode(ControlP5.SWITCH)
              .moveTo(settG)
                ;
  cp5.addTextlabel("pickerFillLabel")
    .setPosition(5, 90)
      .setText("RIEMPIMENTO FORME ATTIVE")
        .moveTo(settG)
          ;
  cp5.addTextfield("inputRFillActive")
    .setLabel("")
    .setPosition(150,105)
    .setSize(25,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.INTEGER)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickRFillActive")
    .setLabel("R")
      .setPosition(5, 105)
        .setSize(132, 10)
          .setColorValue(currentSettings.getFillRActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addTextfield("inputGFillActive")
    .setLabel("")
    .setPosition(150,116)
    .setSize(25,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.INTEGER)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickGFillActive")
    .setLabel("G")
      .setPosition(5, 116)
        .setSize(132, 10)
          .setColorValue(currentSettings.getFillGActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addTextfield("inputBFillActive")
    .setLabel("")
    .setPosition(150,127)
    .setSize(25,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.INTEGER)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickBFillActive")
    .setLabel("B")
      .setPosition(5, 127)
        .setSize(132, 10)
          .setColorValue(currentSettings.getFillBActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addTextfield("inputAFillActive")
    .setLabel("")
    .setPosition(150,138)
    .setSize(25,11)
    .setColorBackground(0)
    .setInputFilter(ControlP5.INTEGER)
    .setFocus(false)
    .setAutoClear(false)
    .setColor(color(255,0,0))
    .setColorActive(255)
    .moveTo(settG)
    ;
  cp5.addSlider("pickAFillActive")
    .setLabel("A")
      .setPosition(5, 138)
        .setSize(132, 10)
          .setColorValue(currentSettings.getFillAActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addToggle("toggleFillActive")
    .setLabel("Fill ON")
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
  cp5.addSlider("pickRStrokeActive")
    .setLabel("R")
      .setPosition(5, 210)
        .setSize(160, 10)
          .setColorValue(currentSettings.getStrokeRActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addSlider("pickGStrokeActive")
    .setLabel("G")
      .setPosition(5, 221)
        .setSize(160, 10)
          .setColorValue(currentSettings.getStrokeGActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addSlider("pickBStrokeActive")
    .setLabel("B")
      .setPosition(5, 232)
        .setSize(160, 10)
          .setColorValue(currentSettings.getStrokeBActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addSlider("pickAStrokeActive")
    .setLabel("A")
      .setPosition(5, 243)
        .setSize(160, 10)
          .setColorValue(currentSettings.getStrokeAActive())
            .setColorForeground(color(255, 255, 255))
              .setRange(0, 255)
                .moveTo(settG)
                  ;
  cp5.addToggle("toggleStrokeActive")
    .setLabel("Stroke ON")
      .setPosition(5, 255)
        .setSize(42, 15)
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
    .setPosition(40, 66)
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
  /* Message box is shown only upon request */
  winG.hide();

  /* Lock controls @startup */
  manageControls(true);

  /* test if any update downloaded has to be applied */
  updateReady(false); // true to enable startup updates
}

void showPopup(String message, int buttonA, int buttonB)
{
  lockG.show();
  cp5.addTextlabel("messageBoxLabel")
    .setValue(message)
    .setPosition(30,30)
    .setSize(100,100)
    .moveTo(winG)
    ;

  /// button A
  // 0: genericOK
  // 1: overwriteOK
  // 2: downloadUpdateOK
  // 3: applyUpdateOK

  /// button B
  // 0: genericCancel
  // 1: applyUpdateCancel

  // reset buttons
  winG.getController("buttonGenericOK").hide();
  winG.getController("buttonOverwriteOK").hide();
  winG.getController("buttonDownloadUpdateOK").hide();
  winG.getController("buttonApplyUpdateOK").hide();
  winG.getController("buttonGenericCancel").hide();
  winG.getController("buttonApplyUpdateCancel").hide();
  
  switch(buttonA) {
  case 0:
    winG.getController("buttonGenericOK").show();
    break;
  case 1:
    winG.getController("buttonOverwriteOK").show();
    break;
  case 2:
    winG.getController("buttonDownloadUpdateOK").show();
    break;
  case 3:
    winG.getController("buttonApplyUpdateOK").show();
    break;
  }

  switch(buttonB) {
  case 0:
    winG.getController("buttonGenericCancel").show();
    break;
  case 1:
    winG.getController("buttonApplyUpdateCancel").show();
    break;
  }
  
  // if (buttonCancel)
  //   winG.getController("buttonCancel").show();
  // else
  //   winG.getController("buttonCancel").hide();
  // if (buttonOkInfo)
  //   winG.getController("buttonOkInfo").show();
  // else
  //   winG.getController("buttonOkInfo").hide();
  // if (buttonOkOverwrite)
  //   winG.getController("buttonOkOverwrite").show();
  // else
  //   winG.getController("buttonOkOverwrite").hide();
  
  winG.show();
}

void killPopup()
{
  winG.getController("messageBoxLabel").remove();
  winG.hide();
  lockG.hide();
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

/* CP5 objects callbacks */
void rowsNum(int val)
{
  currentGrid.setRows(val);
}
void colsNum(int val)
{
  currentGrid.setColumns(val);
}
void cellWidth(float val) {
  currentGrid.setCellWidth(val);
  if (currentSettings.getKeepCellRatio())
    currentGrid.setCellHeight(val);
  if (currentSettings.getShapesLikeCells())
  {
    currentSettings.setShapeWidth(currentGrid.getCellWidth());
    currentSettings.setShapeHeight(currentGrid.getCellHeight());
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
  if (currentSettings.getShapesLikeCells())
  {
    currentSettings.setShapeWidth(currentGrid.getCellWidth());
    currentSettings.setShapeHeight(currentGrid.getCellHeight());
  }
  Textfield txt = ((Textfield)cp5.getController("inputCellHeight"));
  txt.setValue(String.format("%.2f", val));
}
void inputCellHeight(String val) {
  val = val.replace(',', '.');
  cp5.controller("cellHeight").setValue(float(val));
}
void shapeWidth(float val) {
  currentSettings.setShapeWidth(val);
  if (currentSettings.getKeepShapeRatio())
    currentSettings.setShapeHeight(val);
  Textfield txt = ((Textfield)cp5.getController("inputShapeWidth"));
  txt.setValue(String.format("%.2f", val));
}
void inputShapeWidth(String val) {
  val = val.replace(',', '.');
  cp5.controller("shapeWidth").setValue(float(val));
}
void shapeHeight(float val) {
  currentSettings.setShapeHeight(val);
  if (currentSettings.getKeepShapeRatio())
    currentSettings.setShapeWidth(val);
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
void updateControls()
{
  // gridG
  cp5.getController("cellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("cellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("inputCellWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("inputCellHeight").setValue(currentGrid.getCellHeight());
  cp5.getController("toggleKeepCellRatio").setValue(currentSettings.getKeepCellRatio()?1:0);
  cp5.getController("toggleShowGrid").setValue(currentSettings.getShowGrid()?1:0);
  // settG
  cp5.getController("shapeWidth").setValue(currentSettings.getShapeWidth());
  cp5.getController("shapeHeight").setValue(currentSettings.getShapeHeight());
  cp5.getController("inputShapeWidth").setValue(currentSettings.getShapeWidth());
  cp5.getController("inputShapeHeight").setValue(currentSettings.getShapeHeight());
  cp5.getController("toggleKeepShapeRatio").setValue(currentSettings.getKeepShapeRatio()?1:0);
  cp5.getController("toggleShapesLikeCells").setValue(currentSettings.getShapesLikeCells()?1:0);
  cp5.getController("pickRFillActive").setValue(currentSettings.getFillRActive());
  cp5.getController("pickGFillActive").setValue(currentSettings.getFillGActive());
  cp5.getController("pickBFillActive").setValue(currentSettings.getFillBActive());
  cp5.getController("pickAFillActive").setValue(currentSettings.getFillAActive());
  cp5.getController("inputRFillActive").setValue(currentSettings.getFillRActive());
  cp5.getController("inputGFillActive").setValue(currentSettings.getFillGActive());
  cp5.getController("inputBFillActive").setValue(currentSettings.getFillBActive());
  cp5.getController("inputAFillActive").setValue(currentSettings.getFillAActive());
  cp5.getController("toggleFillActive").setValue(currentSettings.isFillOnActive()?1:0);
  cp5.getController("pickRStrokeActive").setValue(currentSettings.getStrokeRActive());
  cp5.getController("pickGStrokeActive").setValue(currentSettings.getStrokeGActive());
  cp5.getController("pickBStrokeActive").setValue(currentSettings.getStrokeBActive());
  cp5.getController("pickAStrokeActive").setValue(currentSettings.getStrokeAActive());
  cp5.getController("toggleStrokeActive").setValue(currentSettings.isStrokeOnActive()?1:0);
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
  selectOutput("Selezionare destinazione PDF:", "pdfSelected");
}
void checkForUpdate(boolean flag)
{
  updateReady(true);
}
void toggleShowGrid(boolean flag)
{
  currentSettings.setShowGrid(flag);
}
void toggleKeepCellRatio(boolean flag)
{
  currentSettings.setKeepCellRatio(flag);
}
void toggleKeepShapeRatio(boolean flag)
{
  currentSettings.setKeepShapeRatio(flag);
}
void toggleShapesLikeCells(boolean flag)
{
  setLock(cp5.getController("shapeWidth"), flag);
  setLock(cp5.getController("shapeHeight"), flag);
  if (flag)
  {
    currentSettings.setShapeWidth(currentGrid.getCellWidth());
    currentSettings.setShapeHeight(currentGrid.getCellHeight());
  }
  // ensure we have always data mirrored
  cp5.getController("shapeWidth").setValue(currentGrid.getCellWidth());
  cp5.getController("shapeHeight").setValue(currentGrid.getCellHeight());
  
  currentSettings.setShapesLikeCells(flag);
}
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
public void pickRFillActive(int val) {
  currentSettings.setFillRActive(val);
  Textfield txt = ((Textfield)cp5.getController("inputRFillActive"));
  txt.setValue(Integer.toString(val));
}
public void inputRFillActive(String val) {
  cp5.controller("pickRFillActive").setValue(int(val));
}
void pickGFillActive(int val)
{
  currentSettings.setFillGActive(val);
  Textfield txt = ((Textfield)cp5.getController("inputGFillActive"));
  txt.setValue(Integer.toString(val));
}
public void inputGFillActive(String val) {
  cp5.controller("pickGFillActive").setValue(int(val));
}
void pickBFillActive(int val)
{
  currentSettings.setFillBActive(val);
  Textfield txt = ((Textfield)cp5.getController("inputBFillActive"));
  txt.setValue(Integer.toString(val));
}
public void inputBFillActive(String val) {
  cp5.controller("pickBFillActive").setValue(int(val));
}
void pickAFillActive(int val)
{
  currentSettings.setFillAActive(val);
  Textfield txt = ((Textfield)cp5.getController("inputAFillActive"));
  txt.setValue(Integer.toString(val));
}
public void inputAFillActive(String val) {
  cp5.controller("pickAFillActive").setValue(int(val));
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

void drawInactiveCellStub(PGraphics ctx, 
PVector point)
{
  ctx.fill(100, 100, 100);
  ctx.noStroke();
  ctx.rect(point.x, point.y, 5, 5);
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

  println("OFFSET", gridRows, gridCols, matrixRows, matrixCols, xOffset, yOffset);

  /* getting grid sub indices */
  int minRows = min(matrixRows, gridRows);
  int minCols = min(matrixCols, gridCols);
  int startX = (matrixRows < gridRows) ? xOffset : 0;
  int endX = (matrixRows < gridRows) ? minRows + xOffset : minRows;
  int startY = (matrixCols < gridCols) ? yOffset : 0;
  int endY = (matrixCols < gridCols) ? minCols + yOffset : minCols;

  println("STEND ", startX, endX, startY, endY);

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
          drawInactiveCellStub(ctx, currentPoint);
        }
      }
      else /* fake inactive cell */
      {
        drawInactiveCellStub(ctx, currentPoint);
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
}

void draw()
{
  /* Refreshing bg */
  background(bg);

  if (currentSettings.getTransformer() != null)
  {
    /* getting ready for drawing */
    transformer.startDrawing(); // I got some rare random npe here when loading files
    // FIXME: all I get is: golly_vectorializer.pde:1006:0:1006:0: NullPointerException

    /* are we ready to draw? */
    if (currentSettings.getShowGrid()) currentGrid.draw(g, color(204, 204, 204));
    drawGollyPattern(g, currentGrid, currentConfig, currentSettings);

    /* ended drawing */
    transformer.endDrawing();
  }
}

void checkConfigHistory()
{
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
  float shapeWidth = currentSettings.getShapeWidth();
  float shapeHeight = currentSettings.getShapeHeight();

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
  if (currentSettings.getTransformer() != null)
  {
    if (mouseX < x - sizeCP5Group) // avoid sliders conflict
      transformer.saveMousePosition(mouseX, mouseY);
  }
}

void mouseReleased()
{
  if (currentSettings.getTransformer() != null)
  {
    transformer.resetMousePosition();
  }
}

void mouseDragged()
{
  if (currentSettings.getTransformer() != null)
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


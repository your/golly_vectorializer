import java.io.*;
import java.util.*;
import controlP5.*;

GollyRleReader reader;
GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyPatternSettings currentSettings;
Grid2D currentGrid;
ControlP5 cp5;
int x;
int y;
color bg;

void setup()
{
  /** Setting up main display settings */
  x = 1024;
  y = 768;
  bg = color(200,210,200);
  
  size(x,y);
  background(bg);
  noStroke();

  /** Building CP5 objects */
  cp5 = new ControlP5(this);
  cp5.addButton("loadRleConfig")
    .setLabel("Load Golly RLE")
    .setPosition(width-110,20)
    .setSize(100,19)
    ;
  cp5.addButton("rewindHistory")
    .setLabel("< prev")
    .setPosition(width/2-20,height-50)
    .setSize(35,25)
    ;
  cp5.addButton("forwardHistory")
    .setLabel("next >")
    .setPosition(width/2+20,height-50)
    .setSize(35,25)
    ;
  
  /** Global objects init */
  manager = new GollyHistoryManager();
  reader = new GollyRleReader();
  currentSettings = new GollyPatternSettings(bg,10,10);
}

/** CP5 objects callbacks */
void forwardHistory(int status)
{
  manager.forwardHistory();
}
void rewindHistory(int status)
{
  manager.rewindHistory();
}
void loadRleConfig(int status)
{
  selectInput("Select a file to process:", "fileSelected");
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

/** Drawing methods */
 void drawGollyPattern(PGraphics ctx,
                       Grid2D grid,
                       GollyRleConfiguration config,
                       GollyPatternSettings settings)
 {
   PVector origin = new PVector(10,10);
   int cols = config.getMatrixWidth();
   int rows = config.getMatrixHeight();
   float cellWidth = settings.getCellWidth();
   float cellHeight = settings.getCellHeight();
   
   grid = new Grid2D(origin, cols, rows, cellWidth, cellHeight);
   color colorFillActive = color(settings.getFillRActive(),
                                 settings.getFillGActive(),
                                 settings.getFillBActive());
   color colorStrokeActive = color(settings.getStrokeRActive(),
                                   settings.getStrokeGActive(),
                                   settings.getStrokeBActive());
   grid.draw(ctx,colorStrokeActive);
 }

 void draw()
 {
   background(bg);
   currentConfig = manager.getCurrentConfiguration();
   if (currentConfig != null)
   {
     drawGollyPattern(g, currentGrid, currentConfig, currentSettings);
   }
   
   //drawGuiElements

   //
 }

 /** Golly file loader */
 void loadGollyFile(String gollyFile) {
   /** Trying to get configuration from parser */
   try {
     GollyRleConfiguration newConfig = reader.parseFile(gollyFile);
     System.out.println("States read: " + newConfig.enumStates());
     /** Adding it to history */
     manager.addConfiguration(newConfig);
   } catch (RuntimeException e) {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
  } catch (IOException e) {
    System.err.println("ERROR: " + e.getMessage());
  }
  
}

/* File -> GollyRleReader -> GollyRleConfiguration -> add to history */

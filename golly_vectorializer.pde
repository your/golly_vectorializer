import java.io.*;
import java.util.*;
import controlP5.*;

GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
GollyRleReader reader;
ControlP5 cp5;

void setup()
{
  size(400,600);
  noStroke();
  
  cp5 = new ControlP5(this);
  cp5.addButton("loadRleConfig")
    .setLabel("Load Golly RLE")
    .setPosition(100,100)
    .setSize(200,19)
    ;

  manager = new GollyHistoryManager();
  reader = new GollyRleReader();
}

void loadRleConfig(int status)
{
  selectInput("Select a file to process:", "fileSelected");
}

// todo: why don't we keep track of the last used folder?
// (from the last program termination)
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String gollyFilePath = selection.getAbsolutePath();
    println("User selected " + gollyFilePath);
    loadGollyFile(gollyFilePath);
  }
}

void drawGollyPattern(PGraphics ctx,
                      Grid2D grid,
                      GollyRleConfiguration config
                      /*, settings */)
{
}

void draw()
{
  //drawGollyPattern(g, currentGrid, currentConfig, currentSettings);

  //drawGuiElements

  //
}

/** Golly file loader */
void loadGollyFile(String gollyFile) {
  /** Trying to get configuration from parser */
  try {
    currentConfig = reader.parseFile(gollyFile);
  } catch (RuntimeException e) {
    System.err.println("ERROR: File is possibly NOT in a valid golly RLE format!");
  } catch (IOException e) {
    System.err.println("ERROR: " + e.getMessage());
  }
  /** Adding it to history */
  manager.addConfiguration(currentConfig);
}

/* File -> GollyRleReader -> GollyRleConfiguration -> add to history */

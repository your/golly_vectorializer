GollyHistoryManager manager;
GollyRleConfiguration currentConfig;
//GollyRleReader reader;

void setup()
{
  manager = new GollyHistoryManager();
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
  /** Getting configuration from parser */
  GollyRleReader reader = new GollyRleReader();
  currentConfig = reader.parseFile(gollyFile);
  /** Adding it to history */
  manager.addConfiguration(currentConfig);
}

/* File -> GollyRleReader -> GollyRleConfiguration -> add to history */

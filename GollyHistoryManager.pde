import java.util.ArrayList;

public class GollyHistoryManager {

  /* Members */
  private ArrayList<GollyRleConfiguration> configHistory =
    new ArrayList<GollyRleConfiguration>();
  private ArrayList<GollyPatternSettings> settingsHistory =
    new ArrayList<GollyPatternSettings>();
  private ArrayList<Grid2D> gridHistory = new ArrayList<Grid2D>();

  private int configHistoryIndex = -1;
  private int settingsHistoryIndex = -1;
  private int gridHistoryIndex = -1;

  /* Methods */
  public void addConfiguration(GollyRleConfiguration newConfig) {
    configHistory.add(newConfig);
    configHistoryIndex++;
  }

  public void addSettings(GollyPatternSettings newSettings) {
    settingsHistory.add(newSettings);
    settingsHistoryIndex++;
  }

  public void addGrid(Grid2D newGrid) {
    gridHistory.add(newGrid);
    gridHistoryIndex++;
  }

  public void updateSettingsHistory(GollyPatternSettings updatedSettings) {
    if (settingsHistoryIndex > -1)
      settingsHistory.set(settingsHistoryIndex, updatedSettings);
  }

  public void setCurrentConfiguration(GollyRleConfiguration overwritingConfig) {
    //println("prima: " + configHistory.get(configHistoryIndex));
    configHistory.set(configHistoryIndex, overwritingConfig);
    //println("dopo: " + configHistory.get(configHistoryIndex));
  }

  public void setCurrentGrid(Grid2D overwritingGrid) {
    //println("prima: " + gridHistory.get(gridHistoryIndex));
    gridHistory.set(gridHistoryIndex, overwritingGrid);
    //println("dopo: " + gridHistory.get(gridHistoryIndex));
  }
  
  /* Getters */
  public GollyRleConfiguration getCurrentConfiguration() {
    GollyRleConfiguration currentConfig = null;
    if (configHistoryIndex > -1 ) {
      currentConfig = configHistory.get(configHistoryIndex);
    }
    return currentConfig;
  }
  public GollyPatternSettings getCurrentSettings() {
    GollyPatternSettings currentSettings = null;
    if (settingsHistoryIndex > -1 ) {
      currentSettings = settingsHistory.get(settingsHistoryIndex);
    }
    return currentSettings;
  }  
  public Grid2D getCurrentGrid() {
    Grid2D currentGrid = null;
    if (gridHistoryIndex > -1 ) {
      currentGrid = gridHistory.get(gridHistoryIndex);
    }
    return currentGrid;
  }
  
  /* Going back-and-forth */
  private void forwardConfigHistory() {
    if (configHistoryIndex < configHistory.size() - 1)
      configHistoryIndex++;
  }
  private void rewindConfigHistory() {
    if (configHistoryIndex > 0)
      configHistoryIndex--;
  }
  private void forwardSettingsHistory() {
    if (settingsHistoryIndex < settingsHistory.size() - 1)
      settingsHistoryIndex++;
  }
  private void rewindSettingsHistory() {
    if (settingsHistoryIndex > 0)
      settingsHistoryIndex--;
  }
  private void forwardGridHistory() {
    if (gridHistoryIndex < gridHistory.size() - 1)
      gridHistoryIndex++;
  }
  private void rewindGridHistory() {
    if (gridHistoryIndex > 0)
      gridHistoryIndex--;
  }

  public void forwardHistory() {
    forwardConfigHistory();
    forwardGridHistory();
    forwardSettingsHistory();
  }

  public void rewindHistory() {
    rewindConfigHistory();
    rewindGridHistory();
    rewindSettingsHistory();
  }

  /* Other utilities */
  public boolean hasNextConfig()
  {
    boolean result = false;
    if (configHistoryIndex + 1 < configHistory.size())
      result = true;
    return result;
  }
  public boolean hasPrevConfig()
  {
    boolean result = false;
    if (configHistoryIndex - 1 != -1)
      result = true;
    return result;
  }  
}

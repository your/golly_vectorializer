import java.util.ArrayList;

public class GollyHistoryManager {

  /** Members */
  private ArrayList<GollyRleConfiguration> configHistory =
    new ArrayList<GollyRleConfiguration>();
  private ArrayList<GollyPatternSettings> settingsHistory =
    new ArrayList<GollyPatternSettings>();
  private ArrayList<Grid2D> gridHistory = new ArrayList<Grid2D>();

  private int configHistoryIndex = -1;
  private int settingsHistoryIndex = -1;
  private int gridHistoryIndex = -1;

  /** Constr */
  GollyHistoryManager() {}

  /** Methods */
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
  
  /** Getters */
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
  
  /** Going back-and-forth */
  public void forwardConfigHistory() {
    if (configHistoryIndex < configHistory.size() - 1)
      configHistoryIndex++;
  }
  public void rewindConfigHistory() {
    if (configHistoryIndex > 0)
      configHistoryIndex--;
  }
  public void forwardSettingsHistory() {
    if (settingsHistoryIndex < settingsHistory.size() - 1)
      settingsHistoryIndex++;
  }
  public void rewindSettingsHistory() {
    if (settingsHistoryIndex > 0)
      settingsHistoryIndex--;
  }
  public void forwardGridHistory() {
    if (gridHistoryIndex < gridHistory.size() - 1)
      gridHistoryIndex++;
  }
  public void rewindGridHistory() {
    if (gridHistoryIndex > 0)
      gridHistoryIndex--;
  }
  
}

import java.util.ArrayList;

public class GollyHistoryManager {

  /** Members */
  private ArrayList<GollyRleConfiguration> configHistory =
    new ArrayList<GollyRleConfiguration>();

  private int historyIndex = -1;

  /** Constr */
  GollyHistoryManager() {}

  /** Methods */
  public void addConfiguration(GollyRleConfiguration newConfig) {
    configHistory.add(newConfig);
    historyIndex++;
  }

  /** Checking history emptiness */
  public boolean emptyHistory() {
    return configHistory.isEmpty();
  }

  /** Getting current configuration */
  public GollyRleConfiguration getCurrentConfiguration() {
    GollyRleConfiguration currentConfig = null;
    if (historyIndex > -1 ) {
      currentConfig = configHistory.get(historyIndex);
    }
    return currentConfig;
  }

  /** Going back-and-forth */
  public void forwardHistory() {
    if (historyIndex < configHistory.size() - 1)
      historyIndex++;
  }
  public void rewindHistory() {
    if (historyIndex > 0)
      historyIndex--;
  }
}

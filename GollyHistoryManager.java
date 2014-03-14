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
  }

  /** Checking history emptiness */
  public boolean emptyHistory() {
    boolean isEmpty = false;
    if (configHistory.isEmpty())
      isEmpty = true;
    return isEmpty;
  }

  /** Getting curreng configuration */
  public GollyRleConfiguration getCurrentConfiguration() {
    GollyRleConfiguration currentConfig = configHistory.get(historyIndex);
    return currentConfig;
  }

  /** Going back-and-forth */
  public void forwardHistory() {
    historyIndex++;
  }
  public void rewindHistory() {
    historyIndex--;
  }
}

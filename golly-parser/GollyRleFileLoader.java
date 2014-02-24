import java.util.ArrayList;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class GollyRleFileLoader extends GollyRleBaseListener
{

  /******* members *********/
  private ArrayList<String> errors = new ArrayList<String>();
  private int xPos;
  private int yPos;
  private int cellMultiplier;
  private int cellState;
  private String rule;
  private ArrayList<ArrayList<Integer>> matrix =
    new ArrayList<ArrayList<Integer>>();

  private static final char startingPrefix = 'p';
  private static final char startingActiveState = 'A';
  private static final int states = 24;
  private static final String voidMult = "1";
  private static final String voidPrefix = "None";

  /******* accessors *********/


  /******* utilities *********/
  private void addMatrixRow()
  {
    ArrayList<Integer> row = new ArrayList<Integer>();
    matrix.add(row);
  }

  private void addMatrixCell(int index, int value)
  {
    ArrayList<Integer> row = matrix.get(index);
    row.add(value);
  }

  private void addMatrixCell(int value)
  {
    /* assuming there is at least one row */
    int lastRow = matrix.size() - 1;
    addMatrixCell(lastRow, value);
    System.out.println("Adding cell value: " + value);
  }
  
  private void addEmptyMatrixRow(int columns)
  {
    ArrayList<Integer> row = new ArrayList<Integer>();
    for(int i = 0; i < columns; ++i)
    {
      /* adding zero values */
      row.add(0);
    }
    matrix.add(row);
  }

  private int translatePrefix(String prefix)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char p = prefix.charAt(0);
    return p - startingPrefix + 1;
  }

  private int translateCellState(String state)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char s = state.charAt(0);
    return s - startingActiveState + 1;
  }

  private int translateCellState(String prefix, String state)
  {
    int p = 0;
    int c = translateCellState(state);

    /* If prefix is not void, translate it */
    if (!prefix.equals(voidPrefix))
    {
      p = translatePrefix(prefix);
    }

    return p * states + c;
  }


  /******* listeners overridding ********/
  public void enterRow(GollyRleParser.RowContext ctx)
  {
    /* Entering a row, adding a new one to the matrix */
    addMatrixRow();
    
  }
  
  public void exitYPos(GollyRleParser.YPosContext ctx)
  {
    String val = ctx.UINT().getText();
    yPos = Integer.parseInt(val);
    System.out.println("Y VAL: " + yPos);
  }

  public void exitXPos(GollyRleParser.XPosContext ctx)
  {
    String val = ctx.UINT().getText();
    xPos = Integer.parseInt(val);
    System.out.println("X VAL: " + xPos);
  }

  public void exitRle(GollyRleParser.RleContext ctx)
  {
     System.out.println(matrix);
  }

  public void exitCellPattern(GollyRleParser.CellPatternContext ctx)
  {
    /* Exiting cellPattern, cellMultiplier and cellState are known */
    String mult = voidMult;

    if (ctx.UINT() != null)
    {
       mult = ctx.UINT().getText();
    }
 
    cellMultiplier = Integer.parseInt(mult);

    System.out.println("Found " + cellMultiplier + " cell" + (cellMultiplier==1?"":"s") + ":");

    /* Adding cells */
    for (int i = 0; i<cellMultiplier; ++i)
    {
       addMatrixCell(cellState);
    }
  }

  public void exitEndRow(GollyRleParser.EndRowContext ctx)
  {
    String mult = voidMult;

    if (ctx.UINT() != null)
    {
       mult = ctx.UINT().getText();
    }

    int emptyRowMultiplier = Integer.parseInt(mult) - 1;

    System.out.println("Found " + emptyRowMultiplier + " emptyRow" + (emptyRowMultiplier==1?"":"s") + "!");

    /* Adding (if present) empty rows */
    for (int i = 0; i<emptyRowMultiplier; ++i)
    {
       addEmptyMatrixRow(xPos);
    }
  }

  public void exitSingleActive(GollyRleParser.SingleActiveContext ctx)
  {
    String state = ctx.SINGLE_ACTIVE_STATE().getText();
    cellState = 1;
  }

  public void exitSingleInactive(GollyRleParser.SingleInactiveContext ctx)
  {
    String state = ctx.SINGLE_INACTIVE_STATE().getText();
    cellState = 0;
  }

  public void exitMultiActive(GollyRleParser.MultiActiveContext ctx)
  {
    String prefix;
    String state = ctx.MULTI_ACTIVE_STATE().getText();

    if (ctx.PREFIX_STATE() == null)
    {
      prefix = voidPrefix;
    }
    else
    {
      prefix = ctx.PREFIX_STATE().getText();
    }

    System.out.println("PREFIX: " + prefix + " STATE: " + state);
    cellState = translateCellState(prefix, state);
    System.out.println("Translated: " + cellState);
  //addMatrixCell(cellState);
  }
}




















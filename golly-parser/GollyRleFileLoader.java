import java.util.ArrayList;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class GollyRleFileLoader extends GollyRleBaseListener
{

  /******* members *********/
  private ArrayList<String> errors;
  GollyRleConfiguration config;

  private static final char startingPrefix = 'p';
  private static final char startingActiveState = 'A';
  private static final int states = 24;


  /******* utilities ********/
  public boolean areMatricesEqual(GollyRleConfiguration matrixOne,
                                  GollyRleConfiguration matrixTwo)
  {
    boolean result = false;
    int matrixOneHeight = matrixOne.getMatrixHeight();
    int matrixOneWidth = matrixOne.getMatrixWidth();
    int matrixTwoHeight = matrixTwo.getMatrixHeight();
    int matrixTwoWidth = matrixTwo.getMatrixWidth();

    if (matrixOneHeight != matrixTwoHeight |
        matrixTwoWidth != matrixTwoWidth)
    {
      result = false;
    }
    else
    {
      for (int i = 0; i < matrixOneHeight; i++)
      {
        for (int j = 0; j < matrixOneWidth; j++)
        {
          int matrixOneCell = matrixOne.getCellState(i,j);
          int matrixTwoCell = matrixTwo.getCellState(i,j);
          if (matrixOneCell != matrixTwoCell)
          {
            result = false;
            break;
          }
          else
          {
            result = true;
          }
        }
        if (result == false)
        {
          break;
        }
      }
    }
    return result;
  }

  public int translatePrefix(String prefix)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char p = prefix.charAt(0);
    return p - startingPrefix + 1;
  }

  public int translateCellState(String state)
  {
    /* getting a char, btw the string is assumed to be of length 1 */
    char s = state.charAt(0);
    return s - startingActiveState + 1;
  }

  public int translateCellState(String prefix, String state)
  {
    int p = 0;
    int c = translateCellState(state);

    p = translatePrefix(prefix);

    return p * states + c;
  }
  
  
  /******* constructors *******/
  GollyRleFileLoader()
  {
    this.config = new GollyRleConfiguration();
  }


  /******* accessors *********/
  public GollyRleConfiguration getConfiguration()
  {
    return config;
  }

  /******* listeners overridding ********/
  public void enterRow(GollyRleParser.RowContext ctx)
  {
    /* Entering a row, adding a new one to the matrix */
    config.addMatrixRow();
    
  }

  public void enterFinalRow(GollyRleParser.FinalRowContext ctx)
  {
    /* forget me not: parser rule 'finalRow' could contain another row...
       or *just* cell patterns! In this case new row is needed before proceeding
     */
    if (ctx.END_PATTERN() != null)
    {
      config.addMatrixRow();
    }

  }

  public void exitHeight(GollyRleParser.HeightContext ctx)
  {
    String val = ctx.UINT().getText();
    int height = Integer.parseInt(val);
    config.setMatrixHeight(height);
    //System.out.println("HEIGHT: " + height);
  }

  public void exitWidth(GollyRleParser.WidthContext ctx)
  {
    String val = ctx.UINT().getText();
    int width = Integer.parseInt(val);
    config.setMatrixWidth(width);
    //System.out.println("WIDTH: " + width);
  }

  public void exitHeader(GollyRleParser.HeaderContext ctx)
  {
    config.initMatrix();
  }

  public void exitRle(GollyRleParser.RleContext ctx)
  {
     // config.checkMatrixIntegrity();
     // config.drawMatrix();
  }

  public void exitCellPattern(GollyRleParser.CellPatternContext ctx)
  {
    /* Exiting cellPattern, cellMultiplier and cellState are known */
    int cellMult;

    if (ctx.UINT() != null)
    {
      String mult = ctx.UINT().getText();
      cellMult = Integer.parseInt(mult);
    }
    else
    {
      cellMult = 1;
    }
 
    // int cellMult = Integer.parseInt(mult);
    int cellState = config.getCellState();

    //System.out.println("--> Adding " + cellMult + " cell" + (cellMult==1?"":"s") + " with value: " + cellState);

    /* Adding cells */
    for (int i = 0; i < cellMult; ++i)
    {
       config.addMatrixCell(cellState);
    }
  }

  public void exitEndRow(GollyRleParser.EndRowContext ctx)
  {
    int emptyRowMultiplier;

    if (ctx.UINT() != null)
    {
      String mult = ctx.UINT().getText();
      emptyRowMultiplier = Integer.parseInt(mult) - 1;
    }
    else
    {
      emptyRowMultiplier = 0;
    }

    /* Adding (if present) empty rows */
    config.addEmptyMatrixRow(emptyRowMultiplier);
  }

  public void exitSingleActive(GollyRleParser.SingleActiveContext ctx)
  {
    String state = ctx.SINGLE_ACTIVE_STATE().getText();
    config.setCellState(1);
  }

  public void exitSingleInactive(GollyRleParser.SingleInactiveContext ctx)
  {
    String state = ctx.SINGLE_INACTIVE_STATE().getText();
    config.setCellState(0);
  }

  public void exitMultiActive(GollyRleParser.MultiActiveContext ctx)
  {
    String state = ctx.MULTI_ACTIVE_STATE().getText();
    int cellState;

    if (ctx.PREFIX_STATE() != null)
    {
      String prefix = ctx.PREFIX_STATE().getText();
      cellState = translateCellState(prefix, state);
    }
    else
    {
      cellState = translateCellState(state);
    }

    config.setCellState(cellState);
  }

  public void exitMultiInactive(GollyRleParser.MultiInactiveContext ctx)
  {
    String state = ctx.MULTI_INACTIVE_STATE().getText();
    config.setCellState(0);
  }
}











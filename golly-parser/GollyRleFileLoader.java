import java.util.ArrayList;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class GollyRleFileLoader extends GollyRleBaseListener
{

  /******* members *********/
  GollyRleConfiguration config;
  
  /******* constructors *******/
  GollyRleFileLoader()
  {
    this.config = new GollyRleConfiguration();
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

  public void exitRle(GollyRleParser.RleContext ctx)
  {
     config.checkMatrixIntegrity();
     //config.drawMatrix();
  }

  public void exitCellPattern(GollyRleParser.CellPatternContext ctx)
  {
    /* Exiting cellPattern, cellMultiplier and cellState are known */
    String mult = config.voidMult;

    if (ctx.UINT() != null)
    {
       mult = ctx.UINT().getText();
    }
 
    int cellMult = Integer.parseInt(mult);
    int cellState = config.getCellState();

    //System.out.println("--> Adding " + cellMult + " cell" + (cellMult==1?"":"s") + " with value: " + cellState);

    /* Adding cells */
    for (int i = 0; i<cellMult; ++i)
    {
       config.addMatrixCell(cellState);
    }
  }

  public void exitEndRow(GollyRleParser.EndRowContext ctx)
  {
    String mult = config.voidMult;

    if (ctx.UINT() != null)
    {
       mult = ctx.UINT().getText();
    }

    int emptyRowMultiplier = Integer.parseInt(mult) - 1;

    //System.out.println("--> Adding " + emptyRowMultiplier + " emptyRow" + (emptyRowMultiplier==1?"":"s"));

    /* Adding (if present) empty rows */
    for (int i = 0; i<emptyRowMultiplier; ++i)
    {
       config.addEmptyMatrixRow(config.getMatrixWidth());
    }
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
    String prefix;
    String state = ctx.MULTI_ACTIVE_STATE().getText();

    if (ctx.PREFIX_STATE() == null)
    {
      prefix = config.voidPrefix;
    }
    else
    {
      prefix = ctx.PREFIX_STATE().getText();
    }

    //System.out.println("PREFIX: " + prefix + " STATE: " + state);
    int cellState = config.translateCellState(prefix, state);
    //System.out.println("Translated: " + cellState);
    config.setCellState(cellState);
  }

  public void exitMultiInactive(GollyRleParser.MultiInactiveContext ctx)
  {
    String state = ctx.MULTI_INACTIVE_STATE().getText();
    config.setCellState(0);
  }
}







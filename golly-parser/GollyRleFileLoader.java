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
  private String rule;
  private ArrayList<ArrayList<Integer>> matrix =
    new ArrayList<ArrayList<Integer>>();

  /******* accessors *********/

  
  /******* listeners overridding ********/
  public void exitYPos( GollyRleParser.YPosContext ctx)
  {
    String val = ctx.UINT().getText();
    System.out.println("Y VAL: " + val);
  }


}



















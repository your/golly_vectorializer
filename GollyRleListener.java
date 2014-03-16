// Generated from GollyRle.g4 by ANTLR 4.2
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link GollyRleParser}.
 */
public interface GollyRleListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link GollyRleParser#endRow}.
	 * @param ctx the parse tree
	 */
	void enterEndRow(@NotNull GollyRleParser.EndRowContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#endRow}.
	 * @param ctx the parse tree
	 */
	void exitEndRow(@NotNull GollyRleParser.EndRowContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#cellPattern}.
	 * @param ctx the parse tree
	 */
	void enterCellPattern(@NotNull GollyRleParser.CellPatternContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#cellPattern}.
	 * @param ctx the parse tree
	 */
	void exitCellPattern(@NotNull GollyRleParser.CellPatternContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#cell_state}.
	 * @param ctx the parse tree
	 */
	void enterCell_state(@NotNull GollyRleParser.Cell_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#cell_state}.
	 * @param ctx the parse tree
	 */
	void exitCell_state(@NotNull GollyRleParser.Cell_stateContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#height}.
	 * @param ctx the parse tree
	 */
	void enterHeight(@NotNull GollyRleParser.HeightContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#height}.
	 * @param ctx the parse tree
	 */
	void exitHeight(@NotNull GollyRleParser.HeightContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#pattern}.
	 * @param ctx the parse tree
	 */
	void enterPattern(@NotNull GollyRleParser.PatternContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#pattern}.
	 * @param ctx the parse tree
	 */
	void exitPattern(@NotNull GollyRleParser.PatternContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#MultiActive}.
	 * @param ctx the parse tree
	 */
	void enterMultiActive(@NotNull GollyRleParser.MultiActiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#MultiActive}.
	 * @param ctx the parse tree
	 */
	void exitMultiActive(@NotNull GollyRleParser.MultiActiveContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#rle}.
	 * @param ctx the parse tree
	 */
	void enterRle(@NotNull GollyRleParser.RleContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#rle}.
	 * @param ctx the parse tree
	 */
	void exitRle(@NotNull GollyRleParser.RleContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#width}.
	 * @param ctx the parse tree
	 */
	void enterWidth(@NotNull GollyRleParser.WidthContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#width}.
	 * @param ctx the parse tree
	 */
	void exitWidth(@NotNull GollyRleParser.WidthContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#SingleInactive}.
	 * @param ctx the parse tree
	 */
	void enterSingleInactive(@NotNull GollyRleParser.SingleInactiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#SingleInactive}.
	 * @param ctx the parse tree
	 */
	void exitSingleInactive(@NotNull GollyRleParser.SingleInactiveContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#SingleActive}.
	 * @param ctx the parse tree
	 */
	void enterSingleActive(@NotNull GollyRleParser.SingleActiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#SingleActive}.
	 * @param ctx the parse tree
	 */
	void exitSingleActive(@NotNull GollyRleParser.SingleActiveContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#finalRow}.
	 * @param ctx the parse tree
	 */
	void enterFinalRow(@NotNull GollyRleParser.FinalRowContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#finalRow}.
	 * @param ctx the parse tree
	 */
	void exitFinalRow(@NotNull GollyRleParser.FinalRowContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#row}.
	 * @param ctx the parse tree
	 */
	void enterRow(@NotNull GollyRleParser.RowContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#row}.
	 * @param ctx the parse tree
	 */
	void exitRow(@NotNull GollyRleParser.RowContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#header}.
	 * @param ctx the parse tree
	 */
	void enterHeader(@NotNull GollyRleParser.HeaderContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#header}.
	 * @param ctx the parse tree
	 */
	void exitHeader(@NotNull GollyRleParser.HeaderContext ctx);

	/**
	 * Enter a parse tree produced by {@link GollyRleParser#MultiInactive}.
	 * @param ctx the parse tree
	 */
	void enterMultiInactive(@NotNull GollyRleParser.MultiInactiveContext ctx);
	/**
	 * Exit a parse tree produced by {@link GollyRleParser#MultiInactive}.
	 * @param ctx the parse tree
	 */
	void exitMultiInactive(@NotNull GollyRleParser.MultiInactiveContext ctx);
}
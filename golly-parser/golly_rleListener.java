// Generated from golly_rle.g4 by ANTLR 4.1
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link golly_rleParser}.
 */
public interface golly_rleListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link golly_rleParser#cell_pattern}.
	 * @param ctx the parse tree
	 */
	void enterCell_pattern(@NotNull golly_rleParser.Cell_patternContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#cell_pattern}.
	 * @param ctx the parse tree
	 */
	void exitCell_pattern(@NotNull golly_rleParser.Cell_patternContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#cell_state}.
	 * @param ctx the parse tree
	 */
	void enterCell_state(@NotNull golly_rleParser.Cell_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#cell_state}.
	 * @param ctx the parse tree
	 */
	void exitCell_state(@NotNull golly_rleParser.Cell_stateContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#pattern}.
	 * @param ctx the parse tree
	 */
	void enterPattern(@NotNull golly_rleParser.PatternContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#pattern}.
	 * @param ctx the parse tree
	 */
	void exitPattern(@NotNull golly_rleParser.PatternContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#rle}.
	 * @param ctx the parse tree
	 */
	void enterRle(@NotNull golly_rleParser.RleContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#rle}.
	 * @param ctx the parse tree
	 */
	void exitRle(@NotNull golly_rleParser.RleContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#y_pos}.
	 * @param ctx the parse tree
	 */
	void enterY_pos(@NotNull golly_rleParser.Y_posContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#y_pos}.
	 * @param ctx the parse tree
	 */
	void exitY_pos(@NotNull golly_rleParser.Y_posContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#end_row}.
	 * @param ctx the parse tree
	 */
	void enterEnd_row(@NotNull golly_rleParser.End_rowContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#end_row}.
	 * @param ctx the parse tree
	 */
	void exitEnd_row(@NotNull golly_rleParser.End_rowContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#x_pos}.
	 * @param ctx the parse tree
	 */
	void enterX_pos(@NotNull golly_rleParser.X_posContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#x_pos}.
	 * @param ctx the parse tree
	 */
	void exitX_pos(@NotNull golly_rleParser.X_posContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#end_line}.
	 * @param ctx the parse tree
	 */
	void enterEnd_line(@NotNull golly_rleParser.End_lineContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#end_line}.
	 * @param ctx the parse tree
	 */
	void exitEnd_line(@NotNull golly_rleParser.End_lineContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#inactive_state}.
	 * @param ctx the parse tree
	 */
	void enterInactive_state(@NotNull golly_rleParser.Inactive_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#inactive_state}.
	 * @param ctx the parse tree
	 */
	void exitInactive_state(@NotNull golly_rleParser.Inactive_stateContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#row}.
	 * @param ctx the parse tree
	 */
	void enterRow(@NotNull golly_rleParser.RowContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#row}.
	 * @param ctx the parse tree
	 */
	void exitRow(@NotNull golly_rleParser.RowContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#header}.
	 * @param ctx the parse tree
	 */
	void enterHeader(@NotNull golly_rleParser.HeaderContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#header}.
	 * @param ctx the parse tree
	 */
	void exitHeader(@NotNull golly_rleParser.HeaderContext ctx);

	/**
	 * Enter a parse tree produced by {@link golly_rleParser#active_state}.
	 * @param ctx the parse tree
	 */
	void enterActive_state(@NotNull golly_rleParser.Active_stateContext ctx);
	/**
	 * Exit a parse tree produced by {@link golly_rleParser#active_state}.
	 * @param ctx the parse tree
	 */
	void exitActive_state(@NotNull golly_rleParser.Active_stateContext ctx);
}
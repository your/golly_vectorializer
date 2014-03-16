// Generated from GollyRle.g4 by ANTLR 4.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class GollyRleParser extends Parser {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		ASSGNX=1, ASSGNY=2, CA_RULE=3, ENDLINE=4, END_PATTERN=5, SINGLE_INACTIVE_STATE=6, 
		MULTI_INACTIVE_STATE=7, SINGLE_ACTIVE_STATE=8, PREFIX_STATE=9, MULTI_ACTIVE_STATE=10, 
		COMMENT=11, UINT=12, COMMA=13, EQUAL=14, HASH=15, EXLAM=16, NEWLINE=17, 
		WS=18;
	public static final String[] tokenNames = {
		"<INVALID>", "ASSGNX", "ASSGNY", "CA_RULE", "'$'", "END_PATTERN", "'b'", 
		"'.'", "'o'", "PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", "UINT", 
		"','", "'='", "'#'", "'!'", "NEWLINE", "WS"
	};
	public static final int
		RULE_rle = 0, RULE_header = 1, RULE_width = 2, RULE_height = 3, RULE_pattern = 4, 
		RULE_row = 5, RULE_finalRow = 6, RULE_cellPattern = 7, RULE_cell_state = 8, 
		RULE_activeState = 9, RULE_inactiveState = 10, RULE_endRow = 11;
	public static final String[] ruleNames = {
		"rle", "header", "width", "height", "pattern", "row", "finalRow", "cellPattern", 
		"cell_state", "activeState", "inactiveState", "endRow"
	};

	@Override
	public String getGrammarFileName() { return "GollyRle.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public GollyRleParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class RleContext extends ParserRuleContext {
		public TerminalNode NEWLINE() { return getToken(GollyRleParser.NEWLINE, 0); }
		public TerminalNode EOF() { return getToken(GollyRleParser.EOF, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public TerminalNode COMMENT(int i) {
			return getToken(GollyRleParser.COMMENT, i);
		}
		public HeaderContext header() {
			return getRuleContext(HeaderContext.class,0);
		}
		public List<TerminalNode> COMMENT() { return getTokens(GollyRleParser.COMMENT); }
		public RleContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_rle; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterRle(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitRle(this);
		}
	}

	public final RleContext rle() throws RecognitionException {
		RleContext _localctx = new RleContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_rle);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(27);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(24); match(COMMENT);
				}
				}
				setState(29);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(30); header();
			setState(34);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(31); match(COMMENT);
				}
				}
				setState(36);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(37); pattern();
			setState(39);
			_la = _input.LA(1);
			if (_la==NEWLINE) {
				{
				setState(38); match(NEWLINE);
				}
			}

			setState(44);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(41); match(COMMENT);
				}
				}
				setState(46);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(47); match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class HeaderContext extends ParserRuleContext {
		public TerminalNode NEWLINE() { return getToken(GollyRleParser.NEWLINE, 0); }
		public HeightContext height() {
			return getRuleContext(HeightContext.class,0);
		}
		public List<TerminalNode> WS() { return getTokens(GollyRleParser.WS); }
		public List<TerminalNode> COMMA() { return getTokens(GollyRleParser.COMMA); }
		public TerminalNode CA_RULE() { return getToken(GollyRleParser.CA_RULE, 0); }
		public TerminalNode WS(int i) {
			return getToken(GollyRleParser.WS, i);
		}
		public WidthContext width() {
			return getRuleContext(WidthContext.class,0);
		}
		public TerminalNode COMMA(int i) {
			return getToken(GollyRleParser.COMMA, i);
		}
		public HeaderContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_header; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterHeader(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitHeader(this);
		}
	}

	public final HeaderContext header() throws RecognitionException {
		HeaderContext _localctx = new HeaderContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_header);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(49); width();
			setState(51);
			_la = _input.LA(1);
			if (_la==WS) {
				{
				setState(50); match(WS);
				}
			}

			setState(53); match(COMMA);
			setState(55);
			_la = _input.LA(1);
			if (_la==WS) {
				{
				setState(54); match(WS);
				}
			}

			setState(57); height();
			setState(59);
			switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
			case 1:
				{
				setState(58); match(WS);
				}
				break;
			}
			setState(63);
			_la = _input.LA(1);
			if (_la==COMMA) {
				{
				setState(61); match(COMMA);
				setState(62); match(CA_RULE);
				}
			}

			setState(66);
			_la = _input.LA(1);
			if (_la==WS) {
				{
				setState(65); match(WS);
				}
			}

			setState(69);
			switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
			case 1:
				{
				setState(68); match(NEWLINE);
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class WidthContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(GollyRleParser.UINT, 0); }
		public TerminalNode ASSGNX() { return getToken(GollyRleParser.ASSGNX, 0); }
		public WidthContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_width; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterWidth(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitWidth(this);
		}
	}

	public final WidthContext width() throws RecognitionException {
		WidthContext _localctx = new WidthContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_width);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(71); match(ASSGNX);
			setState(72); match(UINT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class HeightContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(GollyRleParser.UINT, 0); }
		public TerminalNode ASSGNY() { return getToken(GollyRleParser.ASSGNY, 0); }
		public HeightContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_height; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterHeight(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitHeight(this);
		}
	}

	public final HeightContext height() throws RecognitionException {
		HeightContext _localctx = new HeightContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_height);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(74); match(ASSGNY);
			setState(75); match(UINT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PatternContext extends ParserRuleContext {
		public FinalRowContext finalRow() {
			return getRuleContext(FinalRowContext.class,0);
		}
		public RowContext row(int i) {
			return getRuleContext(RowContext.class,i);
		}
		public List<RowContext> row() {
			return getRuleContexts(RowContext.class);
		}
		public PatternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pattern; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterPattern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitPattern(this);
		}
	}

	public final PatternContext pattern() throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_pattern);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(80);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					{
					{
					setState(77); row();
					}
					} 
				}
				setState(82);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
			}
			setState(83); finalRow();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RowContext extends ParserRuleContext {
		public TerminalNode NEWLINE() { return getToken(GollyRleParser.NEWLINE, 0); }
		public EndRowContext endRow() {
			return getRuleContext(EndRowContext.class,0);
		}
		public CellPatternContext cellPattern(int i) {
			return getRuleContext(CellPatternContext.class,i);
		}
		public List<CellPatternContext> cellPattern() {
			return getRuleContexts(CellPatternContext.class);
		}
		public RowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_row; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterRow(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitRow(this);
		}
	}

	public final RowContext row() throws RecognitionException {
		RowContext _localctx = new RowContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_row);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(88);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					{
					{
					setState(85); cellPattern();
					}
					} 
				}
				setState(90);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
			}
			setState(92);
			_la = _input.LA(1);
			if (_la==NEWLINE) {
				{
				setState(91); match(NEWLINE);
				}
			}

			setState(97);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					{
					{
					setState(94); cellPattern();
					}
					} 
				}
				setState(99);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
			}
			setState(100); endRow();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FinalRowContext extends ParserRuleContext {
		public TerminalNode END_PATTERN() { return getToken(GollyRleParser.END_PATTERN, 0); }
		public CellPatternContext cellPattern(int i) {
			return getRuleContext(CellPatternContext.class,i);
		}
		public List<CellPatternContext> cellPattern() {
			return getRuleContexts(CellPatternContext.class);
		}
		public RowContext row() {
			return getRuleContext(RowContext.class,0);
		}
		public TerminalNode ENDLINE() { return getToken(GollyRleParser.ENDLINE, 0); }
		public FinalRowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_finalRow; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterFinalRow(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitFinalRow(this);
		}
	}

	public final FinalRowContext finalRow() throws RecognitionException {
		FinalRowContext _localctx = new FinalRowContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_finalRow);
		int _la;
		try {
			setState(113);
			switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(102); row();
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(104); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(103); cellPattern();
					}
					}
					setState(106); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << SINGLE_INACTIVE_STATE) | (1L << MULTI_INACTIVE_STATE) | (1L << SINGLE_ACTIVE_STATE) | (1L << PREFIX_STATE) | (1L << MULTI_ACTIVE_STATE) | (1L << UINT))) != 0) );
				setState(109);
				_la = _input.LA(1);
				if (_la==ENDLINE) {
					{
					setState(108); match(ENDLINE);
					}
				}

				setState(111); match(END_PATTERN);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CellPatternContext extends ParserRuleContext {
		public Cell_stateContext cell_state() {
			return getRuleContext(Cell_stateContext.class,0);
		}
		public TerminalNode UINT() { return getToken(GollyRleParser.UINT, 0); }
		public CellPatternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cellPattern; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterCellPattern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitCellPattern(this);
		}
	}

	public final CellPatternContext cellPattern() throws RecognitionException {
		CellPatternContext _localctx = new CellPatternContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_cellPattern);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(116);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(115); match(UINT);
				}
			}

			setState(118); cell_state();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Cell_stateContext extends ParserRuleContext {
		public ActiveStateContext activeState() {
			return getRuleContext(ActiveStateContext.class,0);
		}
		public InactiveStateContext inactiveState() {
			return getRuleContext(InactiveStateContext.class,0);
		}
		public Cell_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cell_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterCell_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitCell_state(this);
		}
	}

	public final Cell_stateContext cell_state() throws RecognitionException {
		Cell_stateContext _localctx = new Cell_stateContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_cell_state);
		try {
			setState(122);
			switch (_input.LA(1)) {
			case SINGLE_ACTIVE_STATE:
			case PREFIX_STATE:
			case MULTI_ACTIVE_STATE:
				enterOuterAlt(_localctx, 1);
				{
				setState(120); activeState();
				}
				break;
			case SINGLE_INACTIVE_STATE:
			case MULTI_INACTIVE_STATE:
				enterOuterAlt(_localctx, 2);
				{
				setState(121); inactiveState();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ActiveStateContext extends ParserRuleContext {
		public ActiveStateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_activeState; }
	 
		public ActiveStateContext() { }
		public void copyFrom(ActiveStateContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class MultiActiveContext extends ActiveStateContext {
		public TerminalNode MULTI_ACTIVE_STATE() { return getToken(GollyRleParser.MULTI_ACTIVE_STATE, 0); }
		public TerminalNode PREFIX_STATE() { return getToken(GollyRleParser.PREFIX_STATE, 0); }
		public MultiActiveContext(ActiveStateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterMultiActive(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitMultiActive(this);
		}
	}
	public static class SingleActiveContext extends ActiveStateContext {
		public TerminalNode SINGLE_ACTIVE_STATE() { return getToken(GollyRleParser.SINGLE_ACTIVE_STATE, 0); }
		public SingleActiveContext(ActiveStateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterSingleActive(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitSingleActive(this);
		}
	}

	public final ActiveStateContext activeState() throws RecognitionException {
		ActiveStateContext _localctx = new ActiveStateContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_activeState);
		int _la;
		try {
			setState(129);
			switch (_input.LA(1)) {
			case SINGLE_ACTIVE_STATE:
				_localctx = new SingleActiveContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(124); match(SINGLE_ACTIVE_STATE);
				}
				break;
			case PREFIX_STATE:
			case MULTI_ACTIVE_STATE:
				_localctx = new MultiActiveContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(126);
				_la = _input.LA(1);
				if (_la==PREFIX_STATE) {
					{
					setState(125); match(PREFIX_STATE);
					}
				}

				setState(128); match(MULTI_ACTIVE_STATE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InactiveStateContext extends ParserRuleContext {
		public InactiveStateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_inactiveState; }
	 
		public InactiveStateContext() { }
		public void copyFrom(InactiveStateContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class SingleInactiveContext extends InactiveStateContext {
		public TerminalNode SINGLE_INACTIVE_STATE() { return getToken(GollyRleParser.SINGLE_INACTIVE_STATE, 0); }
		public SingleInactiveContext(InactiveStateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterSingleInactive(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitSingleInactive(this);
		}
	}
	public static class MultiInactiveContext extends InactiveStateContext {
		public TerminalNode MULTI_INACTIVE_STATE() { return getToken(GollyRleParser.MULTI_INACTIVE_STATE, 0); }
		public MultiInactiveContext(InactiveStateContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterMultiInactive(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitMultiInactive(this);
		}
	}

	public final InactiveStateContext inactiveState() throws RecognitionException {
		InactiveStateContext _localctx = new InactiveStateContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_inactiveState);
		try {
			setState(133);
			switch (_input.LA(1)) {
			case SINGLE_INACTIVE_STATE:
				_localctx = new SingleInactiveContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(131); match(SINGLE_INACTIVE_STATE);
				}
				break;
			case MULTI_INACTIVE_STATE:
				_localctx = new MultiInactiveContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(132); match(MULTI_INACTIVE_STATE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EndRowContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(GollyRleParser.UINT, 0); }
		public TerminalNode ENDLINE() { return getToken(GollyRleParser.ENDLINE, 0); }
		public EndRowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_endRow; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).enterEndRow(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof GollyRleListener ) ((GollyRleListener)listener).exitEndRow(this);
		}
	}

	public final EndRowContext endRow() throws RecognitionException {
		EndRowContext _localctx = new EndRowContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_endRow);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(136);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(135); match(UINT);
				}
			}

			setState(138); match(ENDLINE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3\24\u008f\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\3\2\7\2\34\n\2\f\2\16\2\37\13\2\3\2\3\2\7\2#\n\2"+
		"\f\2\16\2&\13\2\3\2\3\2\5\2*\n\2\3\2\7\2-\n\2\f\2\16\2\60\13\2\3\2\3\2"+
		"\3\3\3\3\5\3\66\n\3\3\3\3\3\5\3:\n\3\3\3\3\3\5\3>\n\3\3\3\3\3\5\3B\n\3"+
		"\3\3\5\3E\n\3\3\3\5\3H\n\3\3\4\3\4\3\4\3\5\3\5\3\5\3\6\7\6Q\n\6\f\6\16"+
		"\6T\13\6\3\6\3\6\3\7\7\7Y\n\7\f\7\16\7\\\13\7\3\7\5\7_\n\7\3\7\7\7b\n"+
		"\7\f\7\16\7e\13\7\3\7\3\7\3\b\3\b\6\bk\n\b\r\b\16\bl\3\b\5\bp\n\b\3\b"+
		"\3\b\5\bt\n\b\3\t\5\tw\n\t\3\t\3\t\3\n\3\n\5\n}\n\n\3\13\3\13\5\13\u0081"+
		"\n\13\3\13\5\13\u0084\n\13\3\f\3\f\5\f\u0088\n\f\3\r\5\r\u008b\n\r\3\r"+
		"\3\r\3\r\2\2\16\2\4\6\b\n\f\16\20\22\24\26\30\2\2\u0099\2\35\3\2\2\2\4"+
		"\63\3\2\2\2\6I\3\2\2\2\bL\3\2\2\2\nR\3\2\2\2\fZ\3\2\2\2\16s\3\2\2\2\20"+
		"v\3\2\2\2\22|\3\2\2\2\24\u0083\3\2\2\2\26\u0087\3\2\2\2\30\u008a\3\2\2"+
		"\2\32\34\7\r\2\2\33\32\3\2\2\2\34\37\3\2\2\2\35\33\3\2\2\2\35\36\3\2\2"+
		"\2\36 \3\2\2\2\37\35\3\2\2\2 $\5\4\3\2!#\7\r\2\2\"!\3\2\2\2#&\3\2\2\2"+
		"$\"\3\2\2\2$%\3\2\2\2%\'\3\2\2\2&$\3\2\2\2\')\5\n\6\2(*\7\23\2\2)(\3\2"+
		"\2\2)*\3\2\2\2*.\3\2\2\2+-\7\r\2\2,+\3\2\2\2-\60\3\2\2\2.,\3\2\2\2./\3"+
		"\2\2\2/\61\3\2\2\2\60.\3\2\2\2\61\62\7\2\2\3\62\3\3\2\2\2\63\65\5\6\4"+
		"\2\64\66\7\24\2\2\65\64\3\2\2\2\65\66\3\2\2\2\66\67\3\2\2\2\679\7\17\2"+
		"\28:\7\24\2\298\3\2\2\29:\3\2\2\2:;\3\2\2\2;=\5\b\5\2<>\7\24\2\2=<\3\2"+
		"\2\2=>\3\2\2\2>A\3\2\2\2?@\7\17\2\2@B\7\5\2\2A?\3\2\2\2AB\3\2\2\2BD\3"+
		"\2\2\2CE\7\24\2\2DC\3\2\2\2DE\3\2\2\2EG\3\2\2\2FH\7\23\2\2GF\3\2\2\2G"+
		"H\3\2\2\2H\5\3\2\2\2IJ\7\3\2\2JK\7\16\2\2K\7\3\2\2\2LM\7\4\2\2MN\7\16"+
		"\2\2N\t\3\2\2\2OQ\5\f\7\2PO\3\2\2\2QT\3\2\2\2RP\3\2\2\2RS\3\2\2\2SU\3"+
		"\2\2\2TR\3\2\2\2UV\5\16\b\2V\13\3\2\2\2WY\5\20\t\2XW\3\2\2\2Y\\\3\2\2"+
		"\2ZX\3\2\2\2Z[\3\2\2\2[^\3\2\2\2\\Z\3\2\2\2]_\7\23\2\2^]\3\2\2\2^_\3\2"+
		"\2\2_c\3\2\2\2`b\5\20\t\2a`\3\2\2\2be\3\2\2\2ca\3\2\2\2cd\3\2\2\2df\3"+
		"\2\2\2ec\3\2\2\2fg\5\30\r\2g\r\3\2\2\2ht\5\f\7\2ik\5\20\t\2ji\3\2\2\2"+
		"kl\3\2\2\2lj\3\2\2\2lm\3\2\2\2mo\3\2\2\2np\7\6\2\2on\3\2\2\2op\3\2\2\2"+
		"pq\3\2\2\2qr\7\7\2\2rt\3\2\2\2sh\3\2\2\2sj\3\2\2\2t\17\3\2\2\2uw\7\16"+
		"\2\2vu\3\2\2\2vw\3\2\2\2wx\3\2\2\2xy\5\22\n\2y\21\3\2\2\2z}\5\24\13\2"+
		"{}\5\26\f\2|z\3\2\2\2|{\3\2\2\2}\23\3\2\2\2~\u0084\7\n\2\2\177\u0081\7"+
		"\13\2\2\u0080\177\3\2\2\2\u0080\u0081\3\2\2\2\u0081\u0082\3\2\2\2\u0082"+
		"\u0084\7\f\2\2\u0083~\3\2\2\2\u0083\u0080\3\2\2\2\u0084\25\3\2\2\2\u0085"+
		"\u0088\7\b\2\2\u0086\u0088\7\t\2\2\u0087\u0085\3\2\2\2\u0087\u0086\3\2"+
		"\2\2\u0088\27\3\2\2\2\u0089\u008b\7\16\2\2\u008a\u0089\3\2\2\2\u008a\u008b"+
		"\3\2\2\2\u008b\u008c\3\2\2\2\u008c\u008d\7\6\2\2\u008d\31\3\2\2\2\31\35"+
		"$).\659=ADGRZ^closv|\u0080\u0083\u0087\u008a";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
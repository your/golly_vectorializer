// Generated from golly_rle.g4 by ANTLR 4.1
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class golly_rleParser extends Parser {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__3=1, T__2=2, T__1=3, T__0=4, RULE_=5, END_LINE=6, END_PATTERN=7, SINGLE_INACTIVE_STATE=8, 
		MULTI_INACTIVE_STATE=9, SINGLE_ACTIVE_STATE=10, PREFIX_STATE=11, MULTI_ACTIVE_STATE=12, 
		COMMENT=13, UINT=14, NEWLINE=15, WS=16;
	public static final String[] tokenNames = {
		"<INVALID>", "'x'", "'y'", "','", "'='", "RULE_", "'$'", "'!'", "'b'", 
		"'.'", "'o'", "PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", "UINT", 
		"NEWLINE", "WS"
	};
	public static final int
		RULE_rle = 0, RULE_header = 1, RULE_x_pos = 2, RULE_y_pos = 3, RULE_pattern = 4, 
		RULE_row = 5, RULE_cell_pattern = 6, RULE_cell_state = 7, RULE_active_state = 8, 
		RULE_inactive_state = 9, RULE_end_row = 10, RULE_end_line = 11;
	public static final String[] ruleNames = {
		"rle", "header", "x_pos", "y_pos", "pattern", "row", "cell_pattern", "cell_state", 
		"active_state", "inactive_state", "end_row", "end_line"
	};

	@Override
	public String getGrammarFileName() { return "golly_rle.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public golly_rleParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class RleContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(golly_rleParser.EOF, 0); }
		public PatternContext pattern() {
			return getRuleContext(PatternContext.class,0);
		}
		public TerminalNode COMMENT(int i) {
			return getToken(golly_rleParser.COMMENT, i);
		}
		public HeaderContext header() {
			return getRuleContext(HeaderContext.class,0);
		}
		public List<TerminalNode> COMMENT() { return getTokens(golly_rleParser.COMMENT); }
		public RleContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_rle; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterRle(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitRle(this);
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
			setState(41);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(38); match(COMMENT);
				}
				}
				setState(43);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(44); match(EOF);
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
		public TerminalNode NEWLINE() { return getToken(golly_rleParser.NEWLINE, 0); }
		public Y_posContext y_pos() {
			return getRuleContext(Y_posContext.class,0);
		}
		public TerminalNode RULE_() { return getToken(golly_rleParser.RULE_, 0); }
		public X_posContext x_pos() {
			return getRuleContext(X_posContext.class,0);
		}
		public HeaderContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_header; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterHeader(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitHeader(this);
		}
	}

	public final HeaderContext header() throws RecognitionException {
		HeaderContext _localctx = new HeaderContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_header);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(46); x_pos();
			setState(47); match(3);
			setState(48); y_pos();
			setState(51);
			_la = _input.LA(1);
			if (_la==3) {
				{
				setState(49); match(3);
				setState(50); match(RULE_);
				}
			}

			setState(53); match(NEWLINE);
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

	public static class X_posContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(golly_rleParser.UINT, 0); }
		public X_posContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_x_pos; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterX_pos(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitX_pos(this);
		}
	}

	public final X_posContext x_pos() throws RecognitionException {
		X_posContext _localctx = new X_posContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_x_pos);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(55); match(1);
			setState(56); match(4);
			setState(57); match(UINT);
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

	public static class Y_posContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(golly_rleParser.UINT, 0); }
		public Y_posContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_y_pos; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterY_pos(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitY_pos(this);
		}
	}

	public final Y_posContext y_pos() throws RecognitionException {
		Y_posContext _localctx = new Y_posContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_y_pos);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(59); match(2);
			setState(60); match(4);
			setState(61); match(UINT);
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
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterPattern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitPattern(this);
		}
	}

	public final PatternContext pattern() throws RecognitionException {
		PatternContext _localctx = new PatternContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_pattern);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(64); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(63); row();
				}
				}
				setState(66); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << END_LINE) | (1L << END_PATTERN) | (1L << SINGLE_INACTIVE_STATE) | (1L << MULTI_INACTIVE_STATE) | (1L << SINGLE_ACTIVE_STATE) | (1L << PREFIX_STATE) | (1L << MULTI_ACTIVE_STATE) | (1L << UINT))) != 0) );
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
		public End_rowContext end_row() {
			return getRuleContext(End_rowContext.class,0);
		}
		public Cell_patternContext cell_pattern(int i) {
			return getRuleContext(Cell_patternContext.class,i);
		}
		public List<Cell_patternContext> cell_pattern() {
			return getRuleContexts(Cell_patternContext.class);
		}
		public RowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_row; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterRow(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitRow(this);
		}
	}

	public final RowContext row() throws RecognitionException {
		RowContext _localctx = new RowContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_row);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(71);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					{
					{
					setState(68); cell_pattern();
					}
					} 
				}
				setState(73);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			}
			setState(74); end_row();
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

	public static class Cell_patternContext extends ParserRuleContext {
		public Cell_stateContext cell_state() {
			return getRuleContext(Cell_stateContext.class,0);
		}
		public TerminalNode UINT() { return getToken(golly_rleParser.UINT, 0); }
		public Cell_patternContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cell_pattern; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterCell_pattern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitCell_pattern(this);
		}
	}

	public final Cell_patternContext cell_pattern() throws RecognitionException {
		Cell_patternContext _localctx = new Cell_patternContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_cell_pattern);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(77);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(76); match(UINT);
				}
			}

			setState(79); cell_state();
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
		public Active_stateContext active_state() {
			return getRuleContext(Active_stateContext.class,0);
		}
		public Inactive_stateContext inactive_state() {
			return getRuleContext(Inactive_stateContext.class,0);
		}
		public Cell_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cell_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterCell_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitCell_state(this);
		}
	}

	public final Cell_stateContext cell_state() throws RecognitionException {
		Cell_stateContext _localctx = new Cell_stateContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_cell_state);
		try {
			setState(83);
			switch (_input.LA(1)) {
			case SINGLE_ACTIVE_STATE:
			case PREFIX_STATE:
			case MULTI_ACTIVE_STATE:
				enterOuterAlt(_localctx, 1);
				{
				setState(81); active_state();
				}
				break;
			case SINGLE_INACTIVE_STATE:
			case MULTI_INACTIVE_STATE:
				enterOuterAlt(_localctx, 2);
				{
				setState(82); inactive_state();
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

	public static class Active_stateContext extends ParserRuleContext {
		public TerminalNode MULTI_ACTIVE_STATE() { return getToken(golly_rleParser.MULTI_ACTIVE_STATE, 0); }
		public TerminalNode SINGLE_ACTIVE_STATE() { return getToken(golly_rleParser.SINGLE_ACTIVE_STATE, 0); }
		public TerminalNode PREFIX_STATE() { return getToken(golly_rleParser.PREFIX_STATE, 0); }
		public Active_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_active_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterActive_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitActive_state(this);
		}
	}

	public final Active_stateContext active_state() throws RecognitionException {
		Active_stateContext _localctx = new Active_stateContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_active_state);
		int _la;
		try {
			setState(90);
			switch (_input.LA(1)) {
			case SINGLE_ACTIVE_STATE:
				enterOuterAlt(_localctx, 1);
				{
				setState(85); match(SINGLE_ACTIVE_STATE);
				}
				break;
			case PREFIX_STATE:
			case MULTI_ACTIVE_STATE:
				enterOuterAlt(_localctx, 2);
				{
				setState(87);
				_la = _input.LA(1);
				if (_la==PREFIX_STATE) {
					{
					setState(86); match(PREFIX_STATE);
					}
				}

				setState(89); match(MULTI_ACTIVE_STATE);
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

	public static class Inactive_stateContext extends ParserRuleContext {
		public TerminalNode SINGLE_INACTIVE_STATE() { return getToken(golly_rleParser.SINGLE_INACTIVE_STATE, 0); }
		public TerminalNode MULTI_INACTIVE_STATE() { return getToken(golly_rleParser.MULTI_INACTIVE_STATE, 0); }
		public Inactive_stateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_inactive_state; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterInactive_state(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitInactive_state(this);
		}
	}

	public final Inactive_stateContext inactive_state() throws RecognitionException {
		Inactive_stateContext _localctx = new Inactive_stateContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_inactive_state);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(92);
			_la = _input.LA(1);
			if ( !(_la==SINGLE_INACTIVE_STATE || _la==MULTI_INACTIVE_STATE) ) {
			_errHandler.recoverInline(this);
			}
			consume();
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

	public static class End_rowContext extends ParserRuleContext {
		public TerminalNode END_PATTERN() { return getToken(golly_rleParser.END_PATTERN, 0); }
		public End_lineContext end_line() {
			return getRuleContext(End_lineContext.class,0);
		}
		public End_rowContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_end_row; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterEnd_row(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitEnd_row(this);
		}
	}

	public final End_rowContext end_row() throws RecognitionException {
		End_rowContext _localctx = new End_rowContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_end_row);
		try {
			setState(96);
			switch (_input.LA(1)) {
			case END_LINE:
			case UINT:
				enterOuterAlt(_localctx, 1);
				{
				setState(94); end_line();
				}
				break;
			case END_PATTERN:
				enterOuterAlt(_localctx, 2);
				{
				setState(95); match(END_PATTERN);
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

	public static class End_lineContext extends ParserRuleContext {
		public TerminalNode UINT() { return getToken(golly_rleParser.UINT, 0); }
		public TerminalNode END_LINE() { return getToken(golly_rleParser.END_LINE, 0); }
		public End_lineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_end_line; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).enterEnd_line(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof golly_rleListener ) ((golly_rleListener)listener).exitEnd_line(this);
		}
	}

	public final End_lineContext end_line() throws RecognitionException {
		End_lineContext _localctx = new End_lineContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_end_line);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(99);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(98); match(UINT);
				}
			}

			setState(101); match(END_LINE);
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
		"\3\uacf5\uee8c\u4f5d\u8b0d\u4a45\u78bd\u1b2f\u3378\3\22j\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t\13\4"+
		"\f\t\f\4\r\t\r\3\2\7\2\34\n\2\f\2\16\2\37\13\2\3\2\3\2\7\2#\n\2\f\2\16"+
		"\2&\13\2\3\2\3\2\7\2*\n\2\f\2\16\2-\13\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\5"+
		"\3\66\n\3\3\3\3\3\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\6\6\6C\n\6\r\6\16"+
		"\6D\3\7\7\7H\n\7\f\7\16\7K\13\7\3\7\3\7\3\b\5\bP\n\b\3\b\3\b\3\t\3\t\5"+
		"\tV\n\t\3\n\3\n\5\nZ\n\n\3\n\5\n]\n\n\3\13\3\13\3\f\3\f\5\fc\n\f\3\r\5"+
		"\rf\n\r\3\r\3\r\3\r\2\16\2\4\6\b\n\f\16\20\22\24\26\30\2\3\3\2\n\13i\2"+
		"\35\3\2\2\2\4\60\3\2\2\2\69\3\2\2\2\b=\3\2\2\2\nB\3\2\2\2\fI\3\2\2\2\16"+
		"O\3\2\2\2\20U\3\2\2\2\22\\\3\2\2\2\24^\3\2\2\2\26b\3\2\2\2\30e\3\2\2\2"+
		"\32\34\7\17\2\2\33\32\3\2\2\2\34\37\3\2\2\2\35\33\3\2\2\2\35\36\3\2\2"+
		"\2\36 \3\2\2\2\37\35\3\2\2\2 $\5\4\3\2!#\7\17\2\2\"!\3\2\2\2#&\3\2\2\2"+
		"$\"\3\2\2\2$%\3\2\2\2%\'\3\2\2\2&$\3\2\2\2\'+\5\n\6\2(*\7\17\2\2)(\3\2"+
		"\2\2*-\3\2\2\2+)\3\2\2\2+,\3\2\2\2,.\3\2\2\2-+\3\2\2\2./\7\2\2\3/\3\3"+
		"\2\2\2\60\61\5\6\4\2\61\62\7\5\2\2\62\65\5\b\5\2\63\64\7\5\2\2\64\66\7"+
		"\7\2\2\65\63\3\2\2\2\65\66\3\2\2\2\66\67\3\2\2\2\678\7\21\2\28\5\3\2\2"+
		"\29:\7\3\2\2:;\7\6\2\2;<\7\20\2\2<\7\3\2\2\2=>\7\4\2\2>?\7\6\2\2?@\7\20"+
		"\2\2@\t\3\2\2\2AC\5\f\7\2BA\3\2\2\2CD\3\2\2\2DB\3\2\2\2DE\3\2\2\2E\13"+
		"\3\2\2\2FH\5\16\b\2GF\3\2\2\2HK\3\2\2\2IG\3\2\2\2IJ\3\2\2\2JL\3\2\2\2"+
		"KI\3\2\2\2LM\5\26\f\2M\r\3\2\2\2NP\7\20\2\2ON\3\2\2\2OP\3\2\2\2PQ\3\2"+
		"\2\2QR\5\20\t\2R\17\3\2\2\2SV\5\22\n\2TV\5\24\13\2US\3\2\2\2UT\3\2\2\2"+
		"V\21\3\2\2\2W]\7\f\2\2XZ\7\r\2\2YX\3\2\2\2YZ\3\2\2\2Z[\3\2\2\2[]\7\16"+
		"\2\2\\W\3\2\2\2\\Y\3\2\2\2]\23\3\2\2\2^_\t\2\2\2_\25\3\2\2\2`c\5\30\r"+
		"\2ac\7\t\2\2b`\3\2\2\2ba\3\2\2\2c\27\3\2\2\2df\7\20\2\2ed\3\2\2\2ef\3"+
		"\2\2\2fg\3\2\2\2gh\7\b\2\2h\31\3\2\2\2\16\35$+\65DIOUY\\be";
	public static final ATN _ATN =
		ATNSimulator.deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
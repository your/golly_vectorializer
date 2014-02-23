// Generated from golly_rle.g4 by ANTLR 4.2
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
		T__3=1, T__2=2, T__1=3, T__0=4, RULE_=5, Active_state=6, Inactive_state=7, 
		END_LINE=8, END_PATTERN=9, COMMENT=10, UINT=11, NEWLINE=12, WS=13;
	public static final String[] tokenNames = {
		"<INVALID>", "'x'", "'y'", "','", "'='", "RULE_", "Active_state", "Inactive_state", 
		"'$'", "'!'", "COMMENT", "UINT", "NEWLINE", "WS"
	};
	public static final int
		RULE_rle = 0, RULE_header = 1, RULE_x_pos = 2, RULE_y_pos = 3, RULE_pattern = 4, 
		RULE_row = 5, RULE_cell_pattern = 6, RULE_cell_state = 7, RULE_end_row = 8, 
		RULE_end_line = 9;
	public static final String[] ruleNames = {
		"rle", "header", "x_pos", "y_pos", "pattern", "row", "cell_pattern", "cell_state", 
		"end_row", "end_line"
	};

	@Override
	public String getGrammarFileName() { return "golly_rle.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public golly_rleParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class RleContext extends ParserRuleContext {
		public TerminalNode NEWLINE() { return getToken(golly_rleParser.NEWLINE, 0); }
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
			setState(23);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(20); match(COMMENT);
				}
				}
				setState(25);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(26); header();
			setState(30);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(27); match(COMMENT);
				}
				}
				setState(32);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(33); pattern();
			setState(37);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMENT) {
				{
				{
				setState(34); match(COMMENT);
				}
				}
				setState(39);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(41);
			_la = _input.LA(1);
			if (_la==NEWLINE) {
				{
				setState(40); match(NEWLINE);
				}
			}

			setState(43); match(EOF);
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
			setState(45); x_pos();
			setState(46); match(3);
			setState(47); y_pos();
			setState(50);
			_la = _input.LA(1);
			if (_la==3) {
				{
				setState(48); match(3);
				setState(49); match(RULE_);
				}
			}

			setState(53);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				{
				setState(52); match(NEWLINE);
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
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(64); 
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(63); row();
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(66); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			} while ( _alt!=2 && _alt!=-1 );
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
		public TerminalNode NEWLINE() { return getToken(golly_rleParser.NEWLINE, 0); }
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
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(71);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,7,_ctx);
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
				_alt = getInterpreter().adaptivePredict(_input,7,_ctx);
			}
			setState(75);
			_la = _input.LA(1);
			if (_la==NEWLINE) {
				{
				setState(74); match(NEWLINE);
				}
			}

			setState(80);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					{
					{
					setState(77); cell_pattern();
					}
					} 
				}
				setState(82);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
			}
			setState(83); end_row();
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
			setState(86);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(85); match(UINT);
				}
			}

			setState(88); cell_state();
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
		public TerminalNode Active_state() { return getToken(golly_rleParser.Active_state, 0); }
		public TerminalNode Inactive_state() { return getToken(golly_rleParser.Inactive_state, 0); }
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
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(90);
			_la = _input.LA(1);
			if ( !(_la==Active_state || _la==Inactive_state) ) {
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
		enterRule(_localctx, 16, RULE_end_row);
		try {
			setState(94);
			switch (_input.LA(1)) {
			case END_LINE:
			case UINT:
				enterOuterAlt(_localctx, 1);
				{
				setState(92); end_line();
				}
				break;
			case END_PATTERN:
				enterOuterAlt(_localctx, 2);
				{
				setState(93); match(END_PATTERN);
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
		enterRule(_localctx, 18, RULE_end_line);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(97);
			_la = _input.LA(1);
			if (_la==UINT) {
				{
				setState(96); match(UINT);
				}
			}

			setState(99); match(END_LINE);
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
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3\17h\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t\13\3"+
		"\2\7\2\30\n\2\f\2\16\2\33\13\2\3\2\3\2\7\2\37\n\2\f\2\16\2\"\13\2\3\2"+
		"\3\2\7\2&\n\2\f\2\16\2)\13\2\3\2\5\2,\n\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3"+
		"\5\3\65\n\3\3\3\5\38\n\3\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\6\6\6C\n\6"+
		"\r\6\16\6D\3\7\7\7H\n\7\f\7\16\7K\13\7\3\7\5\7N\n\7\3\7\7\7Q\n\7\f\7\16"+
		"\7T\13\7\3\7\3\7\3\b\5\bY\n\b\3\b\3\b\3\t\3\t\3\n\3\n\5\na\n\n\3\13\5"+
		"\13d\n\13\3\13\3\13\3\13\2\2\f\2\4\6\b\n\f\16\20\22\24\2\3\3\2\b\tj\2"+
		"\31\3\2\2\2\4/\3\2\2\2\69\3\2\2\2\b=\3\2\2\2\nB\3\2\2\2\fI\3\2\2\2\16"+
		"X\3\2\2\2\20\\\3\2\2\2\22`\3\2\2\2\24c\3\2\2\2\26\30\7\f\2\2\27\26\3\2"+
		"\2\2\30\33\3\2\2\2\31\27\3\2\2\2\31\32\3\2\2\2\32\34\3\2\2\2\33\31\3\2"+
		"\2\2\34 \5\4\3\2\35\37\7\f\2\2\36\35\3\2\2\2\37\"\3\2\2\2 \36\3\2\2\2"+
		" !\3\2\2\2!#\3\2\2\2\" \3\2\2\2#\'\5\n\6\2$&\7\f\2\2%$\3\2\2\2&)\3\2\2"+
		"\2\'%\3\2\2\2\'(\3\2\2\2(+\3\2\2\2)\'\3\2\2\2*,\7\16\2\2+*\3\2\2\2+,\3"+
		"\2\2\2,-\3\2\2\2-.\7\2\2\3.\3\3\2\2\2/\60\5\6\4\2\60\61\7\5\2\2\61\64"+
		"\5\b\5\2\62\63\7\5\2\2\63\65\7\7\2\2\64\62\3\2\2\2\64\65\3\2\2\2\65\67"+
		"\3\2\2\2\668\7\16\2\2\67\66\3\2\2\2\678\3\2\2\28\5\3\2\2\29:\7\3\2\2:"+
		";\7\6\2\2;<\7\r\2\2<\7\3\2\2\2=>\7\4\2\2>?\7\6\2\2?@\7\r\2\2@\t\3\2\2"+
		"\2AC\5\f\7\2BA\3\2\2\2CD\3\2\2\2DB\3\2\2\2DE\3\2\2\2E\13\3\2\2\2FH\5\16"+
		"\b\2GF\3\2\2\2HK\3\2\2\2IG\3\2\2\2IJ\3\2\2\2JM\3\2\2\2KI\3\2\2\2LN\7\16"+
		"\2\2ML\3\2\2\2MN\3\2\2\2NR\3\2\2\2OQ\5\16\b\2PO\3\2\2\2QT\3\2\2\2RP\3"+
		"\2\2\2RS\3\2\2\2SU\3\2\2\2TR\3\2\2\2UV\5\22\n\2V\r\3\2\2\2WY\7\r\2\2X"+
		"W\3\2\2\2XY\3\2\2\2YZ\3\2\2\2Z[\5\20\t\2[\17\3\2\2\2\\]\t\2\2\2]\21\3"+
		"\2\2\2^a\5\24\13\2_a\7\13\2\2`^\3\2\2\2`_\3\2\2\2a\23\3\2\2\2bd\7\r\2"+
		"\2cb\3\2\2\2cd\3\2\2\2de\3\2\2\2ef\7\n\2\2f\25\3\2\2\2\17\31 \'+\64\67"+
		"DIMRX`c";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
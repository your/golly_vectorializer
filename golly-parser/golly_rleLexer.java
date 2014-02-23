// Generated from golly_rle.g4 by ANTLR 4.1
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class golly_rleLexer extends Lexer {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__3=1, T__2=2, T__1=3, T__0=4, RULE_=5, END_LINE=6, END_PATTERN=7, SINGLE_INACTIVE_STATE=8, 
		MULTI_INACTIVE_STATE=9, SINGLE_ACTIVE_STATE=10, PREFIX_STATE=11, MULTI_ACTIVE_STATE=12, 
		COMMENT=13, UINT=14, NEWLINE=15, WS=16;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] tokenNames = {
		"<INVALID>",
		"'x'", "'y'", "','", "'='", "RULE_", "'$'", "'!'", "'b'", "'.'", "'o'", 
		"PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", "UINT", "NEWLINE", "WS"
	};
	public static final String[] ruleNames = {
		"T__3", "T__2", "T__1", "T__0", "RULE_", "END_LINE", "END_PATTERN", "SINGLE_INACTIVE_STATE", 
		"MULTI_INACTIVE_STATE", "SINGLE_ACTIVE_STATE", "PREFIX_STATE", "MULTI_ACTIVE_STATE", 
		"COMMENT", "UINT", "RULE_STR", "NEWLINE", "WS"
	};


	public golly_rleLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "golly_rle.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	@Override
	public void action(RuleContext _localctx, int ruleIndex, int actionIndex) {
		switch (ruleIndex) {
		case 16: WS_action((RuleContext)_localctx, actionIndex); break;
		}
	}
	private void WS_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 0: skip();  break;
		}
	}

	public static final String _serializedATN =
		"\3\uacf5\uee8c\u4f5d\u8b0d\u4a45\u78bd\u1b2f\u3378\2\22b\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\7\3"+
		"\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16\7\16F\n"+
		"\16\f\16\16\16I\13\16\3\16\3\16\3\17\6\17N\n\17\r\17\16\17O\3\20\6\20"+
		"S\n\20\r\20\16\20T\3\21\6\21X\n\21\r\21\16\21Y\3\22\6\22]\n\22\r\22\16"+
		"\22^\3\22\3\22\3G\23\3\3\1\5\4\1\7\5\1\t\6\1\13\7\1\r\b\1\17\t\1\21\n"+
		"\1\23\13\1\25\f\1\27\r\1\31\16\1\33\17\1\35\20\1\37\2\1!\21\1#\22\2\3"+
		"\2\b\3\2r{\3\2CZ\3\2\62;\5\2\61;C\\c|\4\2\f\f\17\17\4\2\13\13\"\"e\2\3"+
		"\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2"+
		"\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31"+
		"\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\3%\3\2\2\2\5"+
		"\'\3\2\2\2\7)\3\2\2\2\t+\3\2\2\2\13-\3\2\2\2\r\65\3\2\2\2\17\67\3\2\2"+
		"\2\219\3\2\2\2\23;\3\2\2\2\25=\3\2\2\2\27?\3\2\2\2\31A\3\2\2\2\33C\3\2"+
		"\2\2\35M\3\2\2\2\37R\3\2\2\2!W\3\2\2\2#\\\3\2\2\2%&\7z\2\2&\4\3\2\2\2"+
		"\'(\7{\2\2(\6\3\2\2\2)*\7.\2\2*\b\3\2\2\2+,\7?\2\2,\n\3\2\2\2-.\7t\2\2"+
		"./\7w\2\2/\60\7n\2\2\60\61\7g\2\2\61\62\3\2\2\2\62\63\7?\2\2\63\64\5\37"+
		"\20\2\64\f\3\2\2\2\65\66\7&\2\2\66\16\3\2\2\2\678\7#\2\28\20\3\2\2\29"+
		":\7d\2\2:\22\3\2\2\2;<\7\60\2\2<\24\3\2\2\2=>\7q\2\2>\26\3\2\2\2?@\t\2"+
		"\2\2@\30\3\2\2\2AB\t\3\2\2B\32\3\2\2\2CG\7%\2\2DF\13\2\2\2ED\3\2\2\2F"+
		"I\3\2\2\2GH\3\2\2\2GE\3\2\2\2HJ\3\2\2\2IG\3\2\2\2JK\5!\21\2K\34\3\2\2"+
		"\2LN\t\4\2\2ML\3\2\2\2NO\3\2\2\2OM\3\2\2\2OP\3\2\2\2P\36\3\2\2\2QS\t\5"+
		"\2\2RQ\3\2\2\2ST\3\2\2\2TR\3\2\2\2TU\3\2\2\2U \3\2\2\2VX\t\6\2\2WV\3\2"+
		"\2\2XY\3\2\2\2YW\3\2\2\2YZ\3\2\2\2Z\"\3\2\2\2[]\t\7\2\2\\[\3\2\2\2]^\3"+
		"\2\2\2^\\\3\2\2\2^_\3\2\2\2_`\3\2\2\2`a\b\22\2\2a$\3\2\2\2\b\2GOTY^";
	public static final ATN _ATN =
		ATNSimulator.deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
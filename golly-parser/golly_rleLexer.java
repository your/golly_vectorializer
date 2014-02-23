// Generated from golly_rle.g4 by ANTLR 4.2
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
		T__3=1, T__2=2, T__1=3, T__0=4, RULE_=5, Active_state=6, Inactive_state=7, 
		END_LINE=8, END_PATTERN=9, COMMENT=10, UINT=11, NEWLINE=12, WS=13;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] tokenNames = {
		"<INVALID>",
		"'x'", "'y'", "','", "'='", "RULE_", "Active_state", "Inactive_state", 
		"'$'", "'!'", "COMMENT", "UINT", "NEWLINE", "WS"
	};
	public static final String[] ruleNames = {
		"T__3", "T__2", "T__1", "T__0", "RULE_", "Active_state", "Inactive_state", 
		"END_LINE", "END_PATTERN", "SINGLE_INACTIVE_STATE", "MULTI_INACTIVE_STATE", 
		"SINGLE_ACTIVE_STATE", "PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", 
		"UINT", "RULE_STR", "NEWLINE", "WS"
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
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2\17y\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\6\3"+
		"\6\3\6\5\68\n\6\3\6\3\6\5\6<\n\6\3\6\3\6\3\7\3\7\5\7B\n\7\3\7\5\7E\n\7"+
		"\3\b\3\b\5\bI\n\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16"+
		"\3\17\3\17\3\20\3\20\7\20[\n\20\f\20\16\20^\13\20\3\20\3\20\3\21\6\21"+
		"c\n\21\r\21\16\21d\3\22\6\22h\n\22\r\22\16\22i\3\23\6\23m\n\23\r\23\16"+
		"\23n\3\23\3\23\3\24\6\24t\n\24\r\24\16\24u\3\24\3\24\3\\\2\25\3\3\5\4"+
		"\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\2\27\2\31\2\33\2\35\2\37\f!\r#\2"+
		"%\16\'\17\3\2\b\3\2r{\3\2CZ\3\2\62;\5\2\61;C\\c|\4\2\f\f\17\17\4\2\13"+
		"\13\"\"|\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2"+
		"\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\37\3\2\2\2\2!\3"+
		"\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\3)\3\2\2\2\5+\3\2\2\2\7-\3\2\2\2\t/\3\2"+
		"\2\2\13\61\3\2\2\2\rD\3\2\2\2\17H\3\2\2\2\21J\3\2\2\2\23L\3\2\2\2\25N"+
		"\3\2\2\2\27P\3\2\2\2\31R\3\2\2\2\33T\3\2\2\2\35V\3\2\2\2\37X\3\2\2\2!"+
		"b\3\2\2\2#g\3\2\2\2%l\3\2\2\2\'s\3\2\2\2)*\7z\2\2*\4\3\2\2\2+,\7{\2\2"+
		",\6\3\2\2\2-.\7.\2\2.\b\3\2\2\2/\60\7?\2\2\60\n\3\2\2\2\61\62\7t\2\2\62"+
		"\63\7w\2\2\63\64\7n\2\2\64\65\7g\2\2\65\67\3\2\2\2\668\5\'\24\2\67\66"+
		"\3\2\2\2\678\3\2\2\289\3\2\2\29;\7?\2\2:<\5\'\24\2;:\3\2\2\2;<\3\2\2\2"+
		"<=\3\2\2\2=>\5#\22\2>\f\3\2\2\2?E\5\31\r\2@B\5\33\16\2A@\3\2\2\2AB\3\2"+
		"\2\2BC\3\2\2\2CE\5\35\17\2D?\3\2\2\2DA\3\2\2\2E\16\3\2\2\2FI\5\25\13\2"+
		"GI\5\27\f\2HF\3\2\2\2HG\3\2\2\2I\20\3\2\2\2JK\7&\2\2K\22\3\2\2\2LM\7#"+
		"\2\2M\24\3\2\2\2NO\7d\2\2O\26\3\2\2\2PQ\7\60\2\2Q\30\3\2\2\2RS\7q\2\2"+
		"S\32\3\2\2\2TU\t\2\2\2U\34\3\2\2\2VW\t\3\2\2W\36\3\2\2\2X\\\7%\2\2Y[\13"+
		"\2\2\2ZY\3\2\2\2[^\3\2\2\2\\]\3\2\2\2\\Z\3\2\2\2]_\3\2\2\2^\\\3\2\2\2"+
		"_`\5%\23\2` \3\2\2\2ac\t\4\2\2ba\3\2\2\2cd\3\2\2\2db\3\2\2\2de\3\2\2\2"+
		"e\"\3\2\2\2fh\t\5\2\2gf\3\2\2\2hi\3\2\2\2ig\3\2\2\2ij\3\2\2\2j$\3\2\2"+
		"\2km\t\6\2\2lk\3\2\2\2mn\3\2\2\2nl\3\2\2\2no\3\2\2\2op\3\2\2\2pq\b\23"+
		"\2\2q&\3\2\2\2rt\t\7\2\2sr\3\2\2\2tu\3\2\2\2us\3\2\2\2uv\3\2\2\2vw\3\2"+
		"\2\2wx\b\24\2\2x(\3\2\2\2\r\2\67;ADH\\dinu\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
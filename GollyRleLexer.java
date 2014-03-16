// Generated from GollyRle.g4 by ANTLR 4.2
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class GollyRleLexer extends Lexer {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		ASSGNX=1, ASSGNY=2, CA_RULE=3, ENDLINE=4, END_PATTERN=5, SINGLE_INACTIVE_STATE=6, 
		MULTI_INACTIVE_STATE=7, SINGLE_ACTIVE_STATE=8, PREFIX_STATE=9, MULTI_ACTIVE_STATE=10, 
		COMMENT=11, UINT=12, COMMA=13, EQUAL=14, HASH=15, EXLAM=16, NEWLINE=17, 
		WS=18;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] tokenNames = {
		"<INVALID>",
		"ASSGNX", "ASSGNY", "CA_RULE", "'$'", "END_PATTERN", "'b'", "'.'", "'o'", 
		"PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", "UINT", "','", "'='", 
		"'#'", "'!'", "NEWLINE", "WS"
	};
	public static final String[] ruleNames = {
		"ASSGNX", "ASSGNY", "XCOORD", "YCOORD", "CA_RULE", "RULE_KEYW", "ENDLINE", 
		"END_PATTERN", "SINGLE_INACTIVE_STATE", "MULTI_INACTIVE_STATE", "SINGLE_ACTIVE_STATE", 
		"PREFIX_STATE", "MULTI_ACTIVE_STATE", "COMMENT", "FREE_COMMENT", "UINT", 
		"COMMA", "EQUAL", "HASH", "EXLAM", "NEWLINE", "WS"
	};


	public GollyRleLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "GollyRle.g4"; }

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
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2\24\u0098\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\3\2\3\2\5\2\62"+
		"\n\2\3\2\3\2\5\2\66\n\2\3\3\3\3\5\3:\n\3\3\3\3\3\5\3>\n\3\3\4\3\4\3\5"+
		"\3\5\3\6\3\6\5\6F\n\6\3\6\3\6\5\6J\n\6\3\6\7\6M\n\6\f\6\16\6P\13\6\3\6"+
		"\3\6\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3\t\3\t\3\t\7\t^\n\t\f\t\16\ta\13\t\5"+
		"\tc\n\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\17\3\20"+
		"\7\20s\n\20\f\20\16\20v\13\20\3\20\3\20\5\20z\n\20\3\20\3\20\3\21\6\21"+
		"\177\n\21\r\21\16\21\u0080\3\22\3\22\3\23\3\23\3\24\3\24\3\25\3\25\3\26"+
		"\6\26\u008c\n\26\r\26\16\26\u008d\3\26\3\26\3\27\6\27\u0093\n\27\r\27"+
		"\16\27\u0094\3\27\3\27\4Nt\2\30\3\3\5\4\7\2\t\2\13\5\r\2\17\6\21\7\23"+
		"\b\25\t\27\n\31\13\33\f\35\r\37\2!\16#\17%\20\'\21)\22+\23-\24\3\2\7\3"+
		"\2r{\3\2CZ\3\2\62;\4\2\f\f\17\17\4\2\13\13\"\"\u00a1\2\3\3\2\2\2\2\5\3"+
		"\2\2\2\2\13\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2"+
		"\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2!\3\2\2\2\2#\3"+
		"\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\3/\3\2"+
		"\2\2\5\67\3\2\2\2\7?\3\2\2\2\tA\3\2\2\2\13C\3\2\2\2\rS\3\2\2\2\17X\3\2"+
		"\2\2\21Z\3\2\2\2\23d\3\2\2\2\25f\3\2\2\2\27h\3\2\2\2\31j\3\2\2\2\33l\3"+
		"\2\2\2\35n\3\2\2\2\37t\3\2\2\2!~\3\2\2\2#\u0082\3\2\2\2%\u0084\3\2\2\2"+
		"\'\u0086\3\2\2\2)\u0088\3\2\2\2+\u008b\3\2\2\2-\u0092\3\2\2\2/\61\5\7"+
		"\4\2\60\62\5-\27\2\61\60\3\2\2\2\61\62\3\2\2\2\62\63\3\2\2\2\63\65\5%"+
		"\23\2\64\66\5-\27\2\65\64\3\2\2\2\65\66\3\2\2\2\66\4\3\2\2\2\679\5\t\5"+
		"\28:\5-\27\298\3\2\2\29:\3\2\2\2:;\3\2\2\2;=\5%\23\2<>\5-\27\2=<\3\2\2"+
		"\2=>\3\2\2\2>\6\3\2\2\2?@\7z\2\2@\b\3\2\2\2AB\7{\2\2B\n\3\2\2\2CE\5\r"+
		"\7\2DF\5-\27\2ED\3\2\2\2EF\3\2\2\2FG\3\2\2\2GI\5%\23\2HJ\5-\27\2IH\3\2"+
		"\2\2IJ\3\2\2\2JN\3\2\2\2KM\13\2\2\2LK\3\2\2\2MP\3\2\2\2NO\3\2\2\2NL\3"+
		"\2\2\2OQ\3\2\2\2PN\3\2\2\2QR\5+\26\2R\f\3\2\2\2ST\7t\2\2TU\7w\2\2UV\7"+
		"n\2\2VW\7g\2\2W\16\3\2\2\2XY\7&\2\2Y\20\3\2\2\2Zb\5)\25\2[_\5+\26\2\\"+
		"^\5\37\20\2]\\\3\2\2\2^a\3\2\2\2_]\3\2\2\2_`\3\2\2\2`c\3\2\2\2a_\3\2\2"+
		"\2b[\3\2\2\2bc\3\2\2\2c\22\3\2\2\2de\7d\2\2e\24\3\2\2\2fg\7\60\2\2g\26"+
		"\3\2\2\2hi\7q\2\2i\30\3\2\2\2jk\t\2\2\2k\32\3\2\2\2lm\t\3\2\2m\34\3\2"+
		"\2\2no\5\'\24\2op\5\37\20\2p\36\3\2\2\2qs\13\2\2\2rq\3\2\2\2sv\3\2\2\2"+
		"tu\3\2\2\2tr\3\2\2\2uy\3\2\2\2vt\3\2\2\2wz\5+\26\2xz\7\2\2\3yw\3\2\2\2"+
		"yx\3\2\2\2z{\3\2\2\2{|\b\20\2\2| \3\2\2\2}\177\t\4\2\2~}\3\2\2\2\177\u0080"+
		"\3\2\2\2\u0080~\3\2\2\2\u0080\u0081\3\2\2\2\u0081\"\3\2\2\2\u0082\u0083"+
		"\7.\2\2\u0083$\3\2\2\2\u0084\u0085\7?\2\2\u0085&\3\2\2\2\u0086\u0087\7"+
		"%\2\2\u0087(\3\2\2\2\u0088\u0089\7#\2\2\u0089*\3\2\2\2\u008a\u008c\t\5"+
		"\2\2\u008b\u008a\3\2\2\2\u008c\u008d\3\2\2\2\u008d\u008b\3\2\2\2\u008d"+
		"\u008e\3\2\2\2\u008e\u008f\3\2\2\2\u008f\u0090\b\26\2\2\u0090,\3\2\2\2"+
		"\u0091\u0093\t\6\2\2\u0092\u0091\3\2\2\2\u0093\u0094\3\2\2\2\u0094\u0092"+
		"\3\2\2\2\u0094\u0095\3\2\2\2\u0095\u0096\3\2\2\2\u0096\u0097\b\27\2\2"+
		"\u0097.\3\2\2\2\21\2\61\659=EIN_bty\u0080\u008d\u0094\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
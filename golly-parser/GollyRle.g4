grammar GollyRle;

rle	: COMMENT* header COMMENT* pattern COMMENT* NEWLINE? EOF
	;


header	: xPos ',' yPos (',' RULE_)? NEWLINE?
//header	: xPos ',' yPos  NEWLINE
	;

xPos	: 'x' '=' UINT
	;

yPos	: 'y' '=' UINT
	;

RULE_: 'rule' WS? '=' WS? RULE_STR
	;


pattern	: row+
	;

row	: cellPattern* NEWLINE? cellPattern* end_row
	;

cellPattern : UINT? cell_state
	     ;

cell_state : activeState
	   | inactiveState
	   ;

activeState : SINGLE_ACTIVESTATE
	     | PREFIX_STATE? MULTI_ACTIVESTATE
	     ;

inactiveState : SINGLE_INACTIVESTATE
	       | MULTI_INACTIVESTATE
	       ;
	     
end_row : endLine
	| END_PATTERN
	;
	
endLine : UINT? ENDLINE
	 ;


ENDLINE : '$'
	 ;
	  
END_PATTERN : '!'
	    ;

SINGLE_INACTIVESTATE : 'b'
		      ;

MULTI_INACTIVESTATE : '.'
		     ;
		      
SINGLE_ACTIVESTATE : 'o'
		    ;

PREFIX_STATE : [p-y]
	     ;

MULTI_ACTIVESTATE : [A-X]
		   ;
	   
COMMENT	: '#' .*? NEWLINE
	;

UINT	: [0-9]+
	;

fragment
RULE_STR: [a-zA-Z0-9/]+
	;
	
NEWLINE	: [\n\r]+ -> skip
	;

WS	: [ \t]+ -> skip
	;

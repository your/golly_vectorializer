grammar golly_rle;

rle	: COMMENT* header COMMENT* pattern COMMENT* EOF
	;


header	: x_pos ',' y_pos (',' RULE_)? NEWLINE
//header	: x_pos ',' y_pos  NEWLINE
	;

x_pos	: 'x' '=' UINT
	;

y_pos	: 'y' '=' UINT
	;

RULE_: 'rule' WS? '=' WS? RULE_STR
	;


pattern	: row+
	;

row	: cell_pattern* end_row
	;

cell_pattern : UINT? cell_state
	     ;

cell_state : active_state
	   | inactive_state
	   ;

active_state : SINGLE_ACTIVE_STATE
	     | PREFIX_STATE? MULTI_ACTIVE_STATE
	     ;

inactive_state : SINGLE_INACTIVE_STATE
	       | MULTI_INACTIVE_STATE
	       ;
	     
end_row : end_line
	| END_PATTERN
	;
	
end_line : UINT? END_LINE
	 ;


END_LINE : '$'
	 ;
	  
END_PATTERN : '!'
	    ;

SINGLE_INACTIVE_STATE : 'b'
		      ;

MULTI_INACTIVE_STATE : '.'
		     ;
		      
SINGLE_ACTIVE_STATE : 'o'
		    ;

PREFIX_STATE : [p-y]
	     ;

MULTI_ACTIVE_STATE : [A-X]
		   ;
	   
COMMENT	: '#' .*? NEWLINE
	;

UINT	: [0-9]+
	;

fragment
RULE_STR: [a-zA-Z0-9/]+
	;
	
NEWLINE	: [\n\r]+
	;

WS	: [ \t]+ -> skip
	;

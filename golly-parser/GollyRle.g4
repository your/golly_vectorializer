grammar GollyRle;

rle :
    COMMENT* header COMMENT* pattern COMMENT* NEWLINE? EOF
  ;


header :
    xPos ',' yPos (',' RULE_)? NEWLINE?
  ;

xPos :
    'x' '=' UINT
  ;

yPos :
    'y' '=' UINT
  ;

RULE_ :
    'rule' WS? '=' WS? RULE_STR
  ;

pattern	:
    row* finalRow
  ;

row	: cellPattern* NEWLINE? cellPattern* endRow
  ;

finalRow: row
  | cellPattern+ END_PATTERN
  ;

cellPattern :
    UINT? cell_state
  ;

cell_state :
    activeState
  | inactiveState
  ;

activeState :
    SINGLE_ACTIVE_STATE #SingleActive
  | PREFIX_STATE? MULTI_ACTIVE_STATE #MultiActive
  ;

inactiveState :
    SINGLE_INACTIVE_STATE #SingleInactive
  | MULTI_INACTIVE_STATE #MultiInactive
  ;
	     
// end_row : endLine
// 	| END_PATTERN
// 	;
	
// endLine : UINT? ENDLINE
// 	 ;
endRow :
    UINT? ENDLINE
  ;


ENDLINE :
    '$'
  ;

END_PATTERN :
    '!' (NEWLINE FREE_COMMENT*)?
  ;

SINGLE_INACTIVE_STATE :
    'b'
  ;

MULTI_INACTIVE_STATE :
    '.'
  ;

SINGLE_ACTIVE_STATE :
    'o'
  ;

PREFIX_STATE :
    [p-y]
  ;

MULTI_ACTIVE_STATE :
    [A-X]
  ;
	   
COMMENT	:
    '#' FREE_COMMENT
  ;

fragment
FREE_COMMENT :
     .*? NEWLINE -> skip
  ;
  
UINT :
    [0-9]+
  ;

fragment
RULE_STR:
    [a-zA-Z0-9/]+
  ;
	
NEWLINE	:
    [\n\r]+ -> skip
  ;

WS	:
    [ \t]+ -> skip
  ;

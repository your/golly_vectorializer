grammar GollyRle;

rle :
    COMMENT* header COMMENT* pattern NEWLINE? COMMENT* EOF
  ;


header :
    width WS? COMMA WS? height WS? (COMMA CA_RULE)? WS? NEWLINE?
  ;

width :
    ASSGNX UINT
  ;

height :
    ASSGNY UINT
  ;

ASSGNX :
    XCOORD WS? EQUAL WS?
  ;

ASSGNY :
    YCOORD WS? EQUAL WS?
  ;

fragment
XCOORD :
    'x'
  ;

fragment
YCOORD :
    'y'
  ;

CA_RULE :
    RULE_KEYW WS? EQUAL WS? RULE_STR
  ;

fragment
RULE_KEYW :
    'rule'
;

pattern	:
    row* finalRow
  ;

row :
    cellPattern* NEWLINE? cellPattern* endRow
  ;

finalRow :
    row
  | cellPattern+ ENDLINE? END_PATTERN // <finalRow>$! should be allowed too
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
    EXLAM (NEWLINE FREE_COMMENT*)?
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
    HASH FREE_COMMENT
  ;

fragment
FREE_COMMENT :
     .*? NEWLINE -> skip
  ;
  
UINT :
    [0-9]+
  ;

fragment
RULE_STR :
    [a-zA-Z0-9/:-]+
  ;

COMMA :
    ','
  ;

EQUAL :
    '='
  ;

HASH :
    '#'
  ;

EXLAM :
    '!'
  ;

NEWLINE	:
    [\n\r]+ -> skip
  ;

WS	:
    [ \t]+ -> skip
  ;

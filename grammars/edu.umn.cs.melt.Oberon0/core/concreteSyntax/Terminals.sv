grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

imports silver:langutil:lsp as lsp;

lexer class IDENTIFIER;
lexer class KEYWORD dominates IDENTIFIER, extends {lsp:Keyword};
lexer class OP extends {lsp:Operator};

ignore terminal WhiteSpace /[\r\n\t ]+/;

{--
  /\(\*              -- Opening lparen-star
     ([^\*]+|        -- Anything not including a star
      (\*+[^\*\)]))* -- stars, followed by non-rparen
     \*+\)/          -- Closing stars-rparen
--}
ignore terminal Comment /\(\*([^*]+|(\*+[^*)]))*\*+\)/ lexer classes {lsp:Comment};

terminal Id_t           /[A-Za-z][A-Za-z0-9]*/  lexer classes {IDENTIFIER};
terminal Num_t          /[0-9]+/ lexer classes {lsp:Number};

terminal Or_t     'OR'  precedence = 5, association = left, lexer classes { KEYWORD };
terminal And_t    '&'   precedence = 6, association = left, lexer classes { OP };
terminal EQ_t		  '='   precedence = 9, association = none, lexer classes { OP };
terminal NEQ_t	  '#'   precedence = 9, association = none, lexer classes { OP };
terminal GT_t		  '>'   precedence = 9, association = none, lexer classes { OP };
terminal LT_t		  '<'   precedence = 9, association = none, lexer classes { OP };
terminal GTEQ_t	  '>='  precedence = 9, association = none, lexer classes { OP };
terminal LTEQ_t		'<='  precedence = 9, association = none, lexer classes { OP };

terminal Plus_t		  '+'   precedence = 11, association = left, lexer classes { OP };
terminal Minus_t	  '-'   precedence = 11, association = left, lexer classes { OP };
terminal Multiply_t	'*'   precedence = 12, association = left, lexer classes { OP };

terminal Divide_t	'DIV' precedence = 12, association = left,
                        lexer classes { KEYWORD };
terminal Modulo_t	'MOD' precedence = 12, association = left,
                        lexer classes { KEYWORD };

terminal Not_t		'~'   precedence = 15;

terminal LParen_t	'('   ;
terminal RParen_t	')'   ;
terminal Comma_t	','   ;
terminal Colon_t	':'   ;
terminal Semi_t		';'   ;
terminal Assign_t	':='  ;

terminal Begin_kwd 	'BEGIN'  lexer classes {KEYWORD};
terminal End_kwd 	'END'    lexer classes {KEYWORD};

terminal Dot_t		'.'   ;

terminal If_kwd 	'IF'     lexer classes {KEYWORD};
terminal Then_kwd 	'THEN'   lexer classes {KEYWORD};
terminal Else_kwd 	'ELSE'   lexer classes {KEYWORD};
terminal Elseif_kwd 	'ELSIF'  lexer classes {KEYWORD};

terminal While_kwd 	'WHILE'  lexer classes {KEYWORD};
terminal Do_kwd 	'DO'     lexer classes {KEYWORD};

terminal Const_kwd 	'CONST'  lexer classes {KEYWORD};
terminal Type_kwd 	'TYPE'   lexer classes {KEYWORD};
terminal Var_kwd 	'VAR'    lexer classes {KEYWORD};

terminal Module_kwd 	'MODULE' lexer classes {KEYWORD};


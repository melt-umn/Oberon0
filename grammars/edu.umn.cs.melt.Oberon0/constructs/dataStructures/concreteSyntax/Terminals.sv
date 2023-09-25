grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:concreteSyntax;

imports silver:langutil:lsp as lsp;

terminal LBrack_t	'[';
terminal RBrack_t	']';

terminal Record_kwd 	'RECORD'    lexer classes {KEYWORD};
terminal Array_kwd 	'ARRAY'     lexer classes {KEYWORD};
terminal Of_kwd 	'OF'        lexer classes {KEYWORD};


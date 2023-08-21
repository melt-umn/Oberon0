grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:concreteSyntax;

imports silver:langutil:lsp as lsp;

terminal For_kwd   'FOR'   lexer classes {KEYWORD};
terminal To_kwd    'TO'    lexer classes {KEYWORD};
terminal By_kwd    'BY'    lexer classes {KEYWORD};

terminal Case_kwd  'CASE'  lexer classes {KEYWORD};
terminal Of_kwd    'OF'    lexer classes {KEYWORD};
terminal CaseSep_t '|';
terminal Range_t   '..';

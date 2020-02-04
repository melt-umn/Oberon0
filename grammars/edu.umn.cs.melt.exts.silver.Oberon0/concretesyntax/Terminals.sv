grammar edu:umn:cs:melt:exts:silver:Oberon0:concretesyntax;

imports silver:definition:regex as silver;
imports silver:reflect:concretesyntax;

-- Terminal definitions for quote productions
marking terminal Oberon0Stmt_t 'Oberon0_Stmt'  lexer classes {silver:KEYWORD, silver:RESERVED};
marking terminal Oberon0Expr_t 'Oberon0_Expr'  lexer classes {silver:KEYWORD, silver:RESERVED};

-- Terminal definitions for antiquote productions
terminal EscapeStmt_t '$Stmt'  lexer classes {KEYWORD};
terminal EscapeExpr_t '$Expr'  lexer classes {KEYWORD};
terminal EscapeName_t '$Name'  lexer classes {KEYWORD};

terminal LBracket_t '{';
terminal RBracket_t '}';

-- Workarounds for weirdness with ignore terminals
parser attribute inOberon0::Boolean action { inOberon0 = false; };
terminal InOberon0 '' action { inOberon0 = true; };
terminal NotInOberon0 '' action { inOberon0 = false; };

terminal Wild_t '_';

disambiguate silver:WhiteSpace, edu:umn:cs:melt:Oberon0:core:concreteSyntax:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace
{
  pluck if inOberon0 then WhiteSpace else silver:WhiteSpace;
}

disambiguate silver:WhiteSpace, edu:umn:cs:melt:Oberon0:core:concreteSyntax:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace, silver:RegexChar_t
{
  pluck if inOberon0 then WhiteSpace else silver:WhiteSpace;
}

grammar edu:umn:cs:melt:exts:silver:Oberon0:concretesyntax;

imports silver:langutil only ast;

imports silver:definition:core as silver;
imports silver:extension:patternmatching as silver;
imports edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax;

exports edu:umn:cs:melt:Oberon0:core:concreteSyntax;

-- Silver-to-Oberon0 bridge productions
concrete productions top::silver:Expr
| 'Oberon0_Stmt' '{' cst::Stmts_c '}'
  layout {edu:umn:cs:melt:Oberon0:core:concreteSyntax:WhiteSpace}
  { forwards to quoteStmt(cst.ast, location=top.location); }
| 'Oberon0_Expr' '{' cst::Expr_c '}'
  layout {edu:umn:cs:melt:Oberon0:core:concreteSyntax:WhiteSpace}
  { forwards to quoteExpr(cst.ast, location=top.location); }

-- Oberon0-to-Silver bridge productions
concrete productions top::Stmt_c
| '$Stmt' '{' e::silver:Expr '}'
  layout {silver:WhiteSpace}
  { top.ast = antiquoteStmt(e, location=top.location); }

concrete productions top::Expr_c
| '$Expr' '{' e::silver:Expr '}'
  layout {silver:WhiteSpace}
  { top.ast = antiquoteExpr(e, location=top.location); }

concrete productions top::Name_c
| '$Name' '{' e::silver:Expr '}'
  layout {silver:WhiteSpace}
  { top.ast = antiquoteName(e, location=top.location); }

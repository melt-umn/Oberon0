grammar edu:umn:cs:melt:exts:silver:Oberon0:concretesyntax;

imports silver:langutil only ast;

imports silver:definition:core as silver;
imports silver:extension:patternmatching as silver;
imports edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax;

exports edu:umn:cs:melt:Oberon0:core:concreteSyntax;

-- Silver-to-Oberon0 bridge productions
concrete productions top::silver:Expr
| 'Oberon0_Stmt' InOberon0 '{' cst::Stmts_c '}' NotInOberon0
  { forwards to quoteStmt(cst.ast, location=top.location); }
| 'Oberon0_Expr' InOberon0 '{' cst::Expr_c '}' NotInOberon0
  { forwards to quoteExpr(cst.ast, location=top.location); }

concrete productions top::silver:Pattern
| 'Oberon0_Stmt' InOberon0 '{' cst::Stmts_c '}' NotInOberon0
  { forwards to quoteStmtPattern(cst.ast, location=top.location); }
| 'Oberon0_Expr' InOberon0 '{' cst::Expr_c '}' NotInOberon0
  { forwards to quoteExprPattern(cst.ast, location=top.location); }

-- Oberon0-to-Silver bridge productions
concrete productions top::Stmt_c
| '$Stmt' NotInOberon0 '{' e::silver:Expr '}' InOberon0
  { top.ast = antiquoteStmt(e, location=top.location); }
| '$Stmt' n::silver:IdLower_t
  { top.ast = varStmt(silver:nameIdLower(n, location=n.location), location=top.location); }
| '$Stmt' '_'
  { top.ast = wildStmt(location=top.location); }

concrete productions top::Expr_c
| '$Expr' NotInOberon0 '{' e::silver:Expr '}' InOberon0
  { top.ast = antiquoteExpr(e, location=top.location); }
| '$Expr' n::silver:IdLower_t
  { top.ast = varExpr(silver:nameIdLower(n, location=n.location), location=top.location); }
| '$Expr' '_'
  { top.ast = wildExpr(location=top.location); }

concrete productions top::Name_c
| '$Name' NotInOberon0 '{' e::silver:Expr '}' InOberon0
  { top.ast = antiquoteName(e, location=top.location); }
| '$Name' n::silver:IdLower_t
  { top.ast = varName(silver:nameIdLower(n, location=n.location), location=top.location); }
| '$Name' '_'
  { top.ast = wildName(location=top.location); }

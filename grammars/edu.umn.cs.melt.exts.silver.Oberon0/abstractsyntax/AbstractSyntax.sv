grammar edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax;

imports silver:langutil:pp;

imports silver:compiler:definition:core;
imports silver:compiler:extension:patternmatching;

imports edu:umn:cs:melt:Oberon0:core:abstractSyntax as Oberon0;

-- Silver-to-Oberon0 bridge productions
abstract production quoteStmt
top::Expr ::= ast::Oberon0:Stmt
{
  top.unparse = s"Oberon0_Stmt {${concat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteExpr
top::Expr ::= ast::Oberon0:Expr
{
  top.unparse = s"Oberon0_Expr {${concat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

-- Oberon0-to-Silver bridge productions
abstract production antiquoteStmt
top::Oberon0:Stmt ::= e::Expr
{
  top.pp = pp"$$Stmt{${text(e.unparse)}}";
  forwards to error("No forward");
}

abstract production antiquoteExpr
top::Oberon0:Expr ::= e::Expr
{
  top.pp = pp"$$Expr{${text(e.unparse)}}";
  forwards to error("No forward");
}

abstract production antiquoteName
top::Oberon0:Name ::= e::Expr
{
  top.pp = pp"$$Name{${text(e.unparse)}}";
  forwards to error("No forward");
}

global builtin::Location = txtLoc("silver-Oberon0");

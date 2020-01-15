grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

attribute cTrans occurs on Stmt;

aspect production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{
  s.cTrans = s1.cTrans ++ s2.cTrans;
}

aspect production skip
s::Stmt ::=
{
  s.cTrans = "";
}

aspect production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.cTrans = l.cTrans ++ " = " ++ e.cTrans ++ ";\n";
}

aspect production cond
s::Stmt ::= c::Expr t::Stmt e::Stmt
{
  s.cTrans = "if(" ++ c.cTrans ++ ") {\n" ++ t.cTrans ++ "} else {\n" ++ e.cTrans ++ "}\n";
}

aspect production while
s::Stmt ::= c::Expr body::Stmt
{
  s.cTrans = "while(" ++ c.cTrans ++ ") {\n" ++ body.cTrans ++ "}\n";
}


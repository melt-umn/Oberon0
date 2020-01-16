grammar edu:umn:cs:melt:Oberon0:core:typeChecking;

aspect production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.errors <- checkErrors(e.type, l.type, "Assignment to " ++ pp:show(100, l.pp), s.location);
}

aspect production cond
s::Stmt ::= c::Expr t::Stmt e::Stmt
{
  s.errors <- checkErrors(c.type, booleanType(), "IF condition", s.location);
}

aspect production while
s::Stmt ::= con::Expr body::Stmt
{
  s.errors <- checkErrors(con.type, booleanType(), "WHILE condition", s.location);
}


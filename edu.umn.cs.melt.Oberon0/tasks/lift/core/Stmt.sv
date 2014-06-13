grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

attribute freevars, lifted<Stmt> occurs on Stmt;

aspect production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{
  s.freevars = s1.freevars ++ s2.freevars;
  s.lifted = seqStmt(s1.lifted, s2.lifted, location=s.location);
}

aspect production skip
s::Stmt ::=
{
  s.freevars = [ ];
  s.lifted = skip(location=s.location);
}

aspect production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.freevars = l.freevars ++ e.freevars;
  s.lifted = assign(l.lifted, e.lifted, location=s.location);
}

aspect production cond
s::Stmt ::= c::Expr t::Stmt e::Stmt
{
  s.freevars = c.freevars ++ t.freevars ++ e.freevars;
  s.lifted = cond(c.lifted, t.lifted, e.lifted, location=s.location);
}

aspect production while
s::Stmt ::= c::Expr body::Stmt
{
  s.freevars = c.freevars ++ body.freevars;
  s.lifted = while (c.lifted, body.lifted, location=s.location);
}


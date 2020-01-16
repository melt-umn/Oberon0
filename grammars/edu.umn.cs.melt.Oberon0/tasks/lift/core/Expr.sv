grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

attribute freevars occurs on Expr, LExpr;
attribute lifted<Expr> occurs on Expr;
attribute lifted<LExpr> occurs on LExpr;

aspect production idAccess
e::LExpr ::= id::Name
{
  e.freevars = case id.lookupName of
               | just(constDecl(_,_)) -> []
               | just(d) -> [d]
               | _ -> []
               end;
  e.lifted = idAccess(name(id.lookupName.fromJust.liftedName, location=id.location), location=e.location);
}

aspect production lExpr
e::Expr ::= l::LExpr
{
  e.freevars = l.freevars;
  e.lifted = lExpr(l.lifted, location=e.location);
}

aspect production number
e::Expr ::= n::String
{
  e.freevars = [ ];
  e.lifted = e;
}

aspect production mult
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = mult(l.lifted, r.lifted, location=e.location);
}

aspect production div
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = div(l.lifted, r.lifted, location=e.location);
}

aspect production mod
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = mod(l.lifted, r.lifted, location=e.location);
}

aspect production add
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = add(l.lifted, r.lifted, location=e.location);
}

aspect production sub
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = sub(l.lifted, r.lifted, location=e.location);
}

aspect production not
e::Expr ::= e1::Expr
{
  e.freevars = e1.freevars;
  e.lifted = not(e1.lifted, location=e.location);
}

aspect production and
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = and(l.lifted, r.lifted, location=e.location);
}

aspect production or
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = or(l.lifted, r.lifted, location=e.location);
}

aspect production eq
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = eq(l.lifted, r.lifted, location=e.location);
}

aspect production neq
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = neq(l.lifted, r.lifted, location=e.location);
}

aspect production lt
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = lt(l.lifted, r.lifted, location=e.location);
}

aspect production gt
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = gt(l.lifted, r.lifted, location=e.location);
}

aspect production lte
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = lte(l.lifted, r.lifted, location=e.location);
}

aspect production gte
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = gte(l.lifted, r.lifted, location=e.location);
}


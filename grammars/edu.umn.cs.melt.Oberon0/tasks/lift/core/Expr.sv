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

aspect production eqOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = eqOp(l.lifted, r.lifted, location=e.location);
}

aspect production neqOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = neqOp(l.lifted, r.lifted, location=e.location);
}

aspect production ltOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = ltOp(l.lifted, r.lifted, location=e.location);
}

aspect production gtOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = gtOp(l.lifted, r.lifted, location=e.location);
}

aspect production ltOpe
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = lteOp(l.lifted, r.lifted, location=e.location);
}

aspect production gtOpe
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = gteOp(l.lifted, r.lifted, location=e.location);
}


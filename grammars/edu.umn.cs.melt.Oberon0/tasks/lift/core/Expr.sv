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
  e.lifted = ^e;
}

aspect production mulOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = mulOp(l.lifted, r.lifted, location=e.location);
}

aspect production divOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = divOp(l.lifted, r.lifted, location=e.location);
}

aspect production modOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = modOp(l.lifted, r.lifted, location=e.location);
}

aspect production addOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = addOp(l.lifted, r.lifted, location=e.location);
}

aspect production subOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = subOp(l.lifted, r.lifted, location=e.location);
}

aspect production notOp
e::Expr ::= e1::Expr
{
  e.freevars = e1.freevars;
  e.lifted = notOp(e1.lifted, location=e.location);
}

aspect production andOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = andOp(l.lifted, r.lifted, location=e.location);
}

aspect production orOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = orOp(l.lifted, r.lifted, location=e.location);
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

aspect production lteOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = lteOp(l.lifted, r.lifted, location=e.location);
}

aspect production gteOp
e::Expr ::= l::Expr r::Expr
{
  e.freevars = l.freevars ++ r.freevars;
  e.lifted = gteOp(l.lifted, r.lifted, location=e.location);
}


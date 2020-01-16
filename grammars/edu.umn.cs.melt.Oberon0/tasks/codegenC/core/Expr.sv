grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

attribute cTrans occurs on Expr, LExpr;

aspect production idAccess
e::LExpr ::= id::Name
{
  e.cTrans = id.lookupName.fromJust.varRefTrans;
}

aspect production lExpr
e::Expr ::= l::LExpr
{
  e.cTrans = l.cTrans;
}

aspect production number
e::Expr ::= n::String
{
  e.cTrans = n;
}

aspect production mult
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " * " ++ r.cTrans ++ ")";
}

aspect production div
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " / " ++ r.cTrans ++ ")";
}

aspect production mod
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " % " ++ r.cTrans ++ ")";
}

aspect production add
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " + " ++ r.cTrans ++ ")";
}

aspect production sub
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " - " ++ r.cTrans ++ ")";
}

aspect production not
e::Expr ::= e1::Expr
{
  e.cTrans = "(!" ++ e1.cTrans ++ ")";
}

aspect production and
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " && " ++ r.cTrans ++ ")";
}

aspect production or
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " || " ++ r.cTrans ++ ")";
}

aspect production eq
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " == " ++ r.cTrans ++ ")";
}

aspect production neq
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " != " ++ r.cTrans ++ ")";
}

aspect production lt
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " < " ++ r.cTrans ++ ")";
}

aspect production gt
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " > " ++ r.cTrans ++ ")";
}

aspect production lte
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " <= " ++ r.cTrans ++ ")";
}

aspect production gte
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " >= " ++ r.cTrans ++ ")";
}


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

aspect production eqOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " == " ++ r.cTrans ++ ")";
}

aspect production neqOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " != " ++ r.cTrans ++ ")";
}

aspect production ltOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " < " ++ r.cTrans ++ ")";
}

aspect production gtOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " > " ++ r.cTrans ++ ")";
}

aspect production ltOpe
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " <= " ++ r.cTrans ++ ")";
}

aspect production gtOpe
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " >= " ++ r.cTrans ++ ")";
}


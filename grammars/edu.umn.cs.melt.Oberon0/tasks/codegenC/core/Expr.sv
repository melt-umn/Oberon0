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

aspect production mulOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " * " ++ r.cTrans ++ ")";
}

aspect production divOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " / " ++ r.cTrans ++ ")";
}

aspect production modOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " % " ++ r.cTrans ++ ")";
}

aspect production addOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " + " ++ r.cTrans ++ ")";
}

aspect production subOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " - " ++ r.cTrans ++ ")";
}

aspect production notOp
e::Expr ::= e1::Expr
{
  e.cTrans = "(!" ++ e1.cTrans ++ ")";
}

aspect production andOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " && " ++ r.cTrans ++ ")";
}

aspect production orOp
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

aspect production lteOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " <= " ++ r.cTrans ++ ")";
}

aspect production gteOp
e::Expr ::= l::Expr r::Expr
{
  e.cTrans = "(" ++ l.cTrans ++ " >= " ++ r.cTrans ++ ")";
}


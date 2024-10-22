grammar edu:umn:cs:melt:Oberon0:tasks:lift:dataStructures;

aspect production arrayTypeExpr
t::TypeExpr ::= e::Expr ty::TypeExpr
{
  t.lifted = arrayTypeExpr(e.lifted, ty.lifted, location=t.location);
}

aspect production recordTypeExpr
t::TypeExpr ::= f::Decl
{
  t.lifted = ^t; -- no renaming done on field names.
}


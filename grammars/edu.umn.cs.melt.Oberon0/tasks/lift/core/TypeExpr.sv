grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

attribute lifted<TypeExpr> occurs on TypeExpr;

synthesized attribute cTransSuffix :: String;

aspect production nominalTypeExpr
t::TypeExpr ::= id::TypeName
{
  t.lifted = nominalTypeExpr(typeName(id.lookupName.fromJust.liftedName, location=id.location), location=t.location);
}

aspect production integerTypeExpr
t::TypeExpr ::=
{
  t.lifted = t;
}

aspect production booleanTypeExpr
t::TypeExpr ::=
{
  t.lifted = t;
}


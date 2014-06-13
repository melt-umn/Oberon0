grammar edu:umn:cs:melt:Oberon0:core:typeChecking;

attribute type occurs on TypeExpr;

aspect production nominalTypeExpr
t::TypeExpr ::= id::TypeName
{
  t.type = case id.lookupName of
           | just(r) -> nominalType(id.name, r.type)
           | nothing() -> errorType()
           end;
}

aspect production integerTypeExpr
t::TypeExpr ::=
{
  t.type = integerType();
}

aspect production booleanTypeExpr
t::TypeExpr ::=
{
  t.type = booleanType();
}


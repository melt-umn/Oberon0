grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

attribute cTrans, cTransSuffix occurs on TypeExpr;

{--
 - Suffix to apply to the type. C types are written so strangely.
 -
 - Makes an appearance mainly to support arrays.
 -}
synthesized attribute cTransSuffix :: String;

aspect production nominalTypeExpr
t::TypeExpr ::= id::TypeName
{
  -- All types should end up as top-level typedefs, so the correct thing to do
  -- is just reference it.
  t.cTrans = id.name;
  t.cTransSuffix = "";
}

aspect production integerTypeExpr
t::TypeExpr ::=
{
  t.cTrans = "int";
  t.cTransSuffix = "";
}

aspect production booleanTypeExpr
t::TypeExpr ::=
{
  t.cTrans = "int";
  t.cTransSuffix = "";
}


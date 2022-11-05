grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal TypeExpr with location, pp, env, errors;

propagate errors, env on TypeExpr;

abstract production nominalTypeExpr
t::TypeExpr ::= id::TypeName
{
  t.pp = id.pp;
}

abstract production integerTypeExpr
t::TypeExpr ::=
{
  t.pp = pp:text("INTEGER");
}

abstract production booleanTypeExpr
t::TypeExpr ::=
{
  t.pp = pp:text("BOOLEAN");
}


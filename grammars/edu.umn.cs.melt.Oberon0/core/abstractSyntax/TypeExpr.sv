grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal TypeExpr with location, pp, env, errors;

abstract production nominalTypeExpr
t::TypeExpr ::= id::TypeName
{
  t.pp = id.pp;  t.errors := id.errors;
}

abstract production integerTypeExpr
t::TypeExpr ::=
{
  t.pp = pp:text("INTEGER");  t.errors := [];
}

abstract production booleanTypeExpr
t::TypeExpr ::=
{
  t.pp = pp:text("BOOLEAN");   t.errors := [];
}


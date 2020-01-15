

aspect production paramDeclValue
d::Decl ::= id::Name t::TypeExpr
{
  d.errors <- if t.type.mayPassByValue then []
              else [err(d.location, "Cannot pass type " ++ pp:show(100, t.pp) ++ " by value")];
}

aspect production procDecl
d::Decl ::= id::Name formals::Decl locals::Decl s::Stmt endid::Name
{
  d.type = errorType();
}

{--
 - Whether this type can be passed by value. Used to procedure declarations to
 - raise errors if some other type is in a parameter list by value.
 -
 - Take advantage of default type production to put false on all other types,
 - regardless of whether those types are in other extensions.
 -}
synthesized attribute mayPassByValue :: Boolean occurs on TypeRep;

aspect production integerType
t::TypeRep ::=
{
  t.mayPassByValue = true;
}

aspect production booleanType
t::TypeRep ::=
{
  t.mayPassByValue = true;
}

aspect default production
t::TypeRep ::=
{
  t.mayPassByValue = false;
}


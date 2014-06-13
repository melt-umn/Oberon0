grammar edu:umn:cs:melt:Oberon0:core:typeChecking;

{--
 - Only declarations that might appear in the environment (i.e. as a result of
 - a lookup) need type on them.
 -
 - Thus, irrelevant for seqDecls, varsDecl (note the s), etc.
 -}
attribute type occurs on Decl;

aspect production constDecl
d::Decl ::= id::Name e::Expr
{
  d.type = e.type;
}

aspect production typeDecl
d::Decl ::= id::TypeName t::TypeExpr
{
  d.type = t.type;
}

aspect production varDecl
d::Decl ::= id::Name t::TypeExpr
{
  d.type = t.type;
}

aspect production seqDecl
d::Decl ::= h::Decl  t::Decl
{
  d.type = error("Types of cons decls should never be requested.");
}

aspect production noDecl
d::Decl ::=
{
  d.type = error("Types of nil decls should never be requested.");
}


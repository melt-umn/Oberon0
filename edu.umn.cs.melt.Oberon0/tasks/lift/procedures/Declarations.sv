grammar edu:umn:cs:melt:Oberon0:tasks:lift:procedures;

-- lifted for parameters JUST does renaming... nothing moves out!

aspect production paramDeclValue
d::Decl ::= id::Name t::TypeExpr
{
  d.varRefTrans = id.name;
  d.liftedDecls = [];
  d.lifted = paramDeclValue(name(d.liftedName, location=id.location), t.lifted, location=d.location);
}

aspect production paramDeclReference
d::Decl ::= id::Name t::TypeExpr
{
  d.varRefTrans = "(*" ++ id.name ++ ")";
  d.liftedDecls = [];
  d.lifted = paramDeclReference(name(d.liftedName, location=id.location), t.lifted, location=d.location);
}


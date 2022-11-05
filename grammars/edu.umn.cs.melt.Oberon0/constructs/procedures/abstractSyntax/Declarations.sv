grammar edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

{--
 - Whether this is a pass-by-value declaration or not.
 - If true, then only certain kinds of expressions are permitted 
 - in argument lists.
 -}
synthesized attribute passedByValue :: Boolean occurs on Decl;  --T2

{--
 - List of the procedures in a declaration block.
 -
 - @see vars
 -}
monoid attribute funs :: [Pair<String Decorated Decl>] occurs on Decl;  --T2

propagate funs on Decl;

abstract production paramDeclValue
d::Decl ::= id::Name t::TypeExpr
{
  d.pp = pp:ppConcat([id.pp, pp:text(" : "), t.pp]);
  --T2-start
   d.passedByValue = true;
   d.individualDcls := [d];
   d.vars := [pair(id.name, d)];
   d.newEnv = addDefs(valueDef(id.name, d), d.env);
   propagate env;
  --T2-end
  
  forwards to varDecl(id, t, location=d.location);
}

abstract production paramDeclReference
d::Decl ::= id::Name t::TypeExpr
{
  d.pp = pp:ppConcat([pp:text("VAR "), id.pp, pp:text(" : "), t.pp]);
  --T2-start
   d.passedByValue = false;
   d.individualDcls := [d];
   d.vars := [pair(id.name, d)];
   d.newEnv = addDefs(valueDef(id.name, d), d.env);
   propagate env;
  --T2-end

  forwards to varDecl(id, t, location=d.location);
}

  --T2-start
aspect production seqDecl
d::Decl ::= d1::Decl d2::Decl
{
  d.passedByValue = false;
}

aspect production noDecl
d::Decl ::=
{
  d.passedByValue = false;
}

aspect production constDecl
d::Decl ::= id::Name e::Expr
{
  d.passedByValue = false;
}

aspect production typeDecl
d::Decl ::= id::TypeName t::TypeExpr
{
  d.passedByValue = false;
}

aspect production varDecl
d::Decl ::= id::Name t::TypeExpr
{
  d.passedByValue = false;
}
  --T2-end

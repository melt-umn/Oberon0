grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

imports edu:umn:cs:melt:Oberon0:core;

imports silver:langutil;
imports silver:langutil:pp as pp;

exports edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking
  with edu:umn:cs:melt:Oberon0:core:typeChecking;

abstract production arrayTypeExpr
t::TypeExpr ::= e::Expr ty::TypeExpr
{
  t.pp = pp:ppConcat([pp:text("ARRAY "), e.pp, pp:text(" OF "), ty.pp]);
  
  t.errors := e.errors ++ ty.errors;  --T2
}

abstract production recordTypeExpr
t::TypeExpr ::= f::Decl
{
  t.pp = pp:ppConcat([pp:text("RECORD "), pp:ppImplode(pp:text("; "), map((.pp), f.individualDcls)), pp:text(" END")]);
  
  t.errors := f.errors;  --T2
  
  f.env = newScope(t.env);  --T2
}


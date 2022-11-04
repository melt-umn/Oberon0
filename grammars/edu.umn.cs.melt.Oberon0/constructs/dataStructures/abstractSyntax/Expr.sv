grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;


abstract production arrayAccess
e::LExpr ::= array::LExpr index::Expr
{
  e.pp = pp:cat(array.pp, pp:brackets(index.pp));
  
  propagate errors, env;  --T2
  e.evalConstInt = nothing();  --T2
}

abstract production fieldAccess
e::LExpr ::= rec::LExpr fld::Name
{
  e.pp = pp:ppConcat([rec.pp, pp:text("."), fld.pp]);
  
  propagate errors, env;  --T2
  e.evalConstInt = nothing();  --T2
}


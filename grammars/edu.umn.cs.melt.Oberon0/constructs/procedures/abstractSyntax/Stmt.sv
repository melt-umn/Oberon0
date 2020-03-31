grammar edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

nonterminal Exprs with location, pp, env, errors;

propagate errors on Exprs;  --T2

abstract production callDispatch
s::Stmt ::= f::Name a::Exprs
{
  -- One could also put something in the environment for these names, but
  -- we're explicitly treat them specially here.
  forwards to case f.name of
              | "Write"   -> writeCall(f, a, location=s.location)
              | "WriteLn" -> writeLnCall(f, a, location=s.location)
              | "Read"    -> readCall(f, a, location=s.location)
              | _ -> call(f, a, location=s.location)
              end;
}

abstract production call
s::Stmt ::= f::Name a::Exprs
{
  s.pp = pp:ppConcat([f.pp, pp:parens(a.pp)]);
  
  propagate errors;  --T2
}


abstract production nilExprs
e::Exprs ::=
{
  e.pp = pp:notext();
}

abstract production consExprs
es::Exprs ::= e::Expr rest::Exprs
{
  es.pp = pp:ppConcat([e.pp,
    case rest of 
    | nilExprs() -> pp:notext()
    | _ -> pp:cat(pp:text(", "), rest.pp)
    end ]);
  -- Same thing happens in pretty printing ELSIFs.              
}

abstract production readCall
s::Stmt ::= f::Name e::Exprs
{
  s.pp = pp:ppConcat([pp:text("Read"), pp:parens(e.pp)]);
  s.errors := e.errors;  --T2
}
abstract production writeCall
s::Stmt ::= f::Name e::Exprs
{
  s.pp = pp:ppConcat([pp:text("Write"), pp:parens(e.pp)]);
  s.errors := e.errors;  --T2
}
abstract production writeLnCall
s::Stmt ::= f::Name e::Exprs
{
  s.pp = pp:text("WriteLn");
  s.errors := e.errors;  --T2
}


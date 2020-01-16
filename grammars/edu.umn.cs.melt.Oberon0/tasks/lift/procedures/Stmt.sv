grammar edu:umn:cs:melt:Oberon0:tasks:lift:procedures;

import edu:umn:cs:melt:Oberon0:constructs:procedures:typeChecking;

attribute freevars, lifted<Exprs> occurs on Exprs;

aspect production call
s::Stmt ::= f::Name a::Exprs
{
  s.freevars = [f.lookupName.fromJust] ++ a.freevars;
  s.lifted = call(name(f.lookupName.fromJust.liftedName, location=f.location), extendedArgs(procDecl.sol, a.lifted), location=s.location);

  local procDecl::Decorated Decl =
    case f.lookupName of
    | just(dd) -> dd
    | _ -> error("Asking for decl on call of undeclared procedure..." ++ f.name ++ "\n")
    end;
}

aspect production nilExprs
es::Exprs ::=
{
  es.freevars = [];
  es.lifted = es;
}


aspect production consExprs
es::Exprs ::= e::Expr rest::Exprs
{
  es.freevars = e.freevars ++ rest.freevars;
  es.lifted = consExprs(e.lifted, rest.lifted, location=es.location);
}

 {--
 - Add all non-top-level declarations this procedure requires
 - to the argument list, paralleling extendedParams.
 -
 - @see extendedParams
 -}
function extendedArgs
Exprs ::= toAdd::[Decorated Decl] prev::Exprs
{
  return if null(toAdd) then prev
         else if !d.enclosingProcedure.isJust {- at top level -} then rest
         else consExprs(newArgRef, rest, location=d.location);

  local d::Decorated Decl = head(toAdd);
  local rest::Exprs = extendedArgs(tail(toAdd), prev);
  local newArgRef :: Expr =
    lExpr(idAccess(name(d.liftedName, location=prev.location), location=prev.location), location=prev.location);
}


aspect production readCall
s::Stmt ::= f::Name e::Exprs
{
  s.freevars = e.freevars;
  s.lifted = readCall(f, e.lifted, location=s.location);
}
aspect production writeCall
s::Stmt ::= f::Name e::Exprs
{
  s.freevars = e.freevars;
  s.lifted = writeCall(f, e.lifted, location=s.location);
}
aspect production writeLnCall
s::Stmt ::= f::Name e::Exprs
{
  s.freevars = e.freevars;
  s.lifted = writeLnCall(f, e.lifted, location=s.location);
}


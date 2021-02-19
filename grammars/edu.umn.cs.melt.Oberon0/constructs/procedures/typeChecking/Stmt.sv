grammar edu:umn:cs:melt:Oberon0:constructs:procedures:typeChecking;

imports edu:umn:cs:melt:Oberon0:core;
imports edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;
imports edu:umn:cs:melt:Oberon0:core:typeChecking;

imports silver:langutil;
imports silver:langutil:pp as pp;

aspect production call
s::Stmt ::= f::Name a::Exprs
{
  a.procName = f;

  s.errors <-
    case f.lookupName of
    | just(procDecl(_, params1, _, _, _)) -> []
    | _ -> [err(s.location, f.name ++ " is not a procedure, and cannot be called!")]
    end;

  a.paramsKnown =
    case f.lookupName of
    | just(procDecl(_, params1, _, _, _)) -> just(params1.vars)
    | _ -> nothing()
    end;
}

{--
 - The expected types of a procedure call.  The type is somewhat daunting:
 - Either there are known parameter types, or there are not, hence the Maybe.
 -   (Why not? Examples: unknown procedure. Or too many parameters.)
 - After that is the list of name-decl pairs, from which the type can be 
 -  obtained. 
 -   (Note: empty list is possible and meaningful: no more expected parameters)
 -   (Why name/decl? Easy to get, and we need info from the decl to find out
 -    if it's pass by reference or by value, as that is not reflected in the type.)
 -}
inherited attribute paramsKnown :: Maybe<[Pair<String  Decorated Decl>]> occurs on Exprs;
{--
 - The name of the procedure being called, given to the parameter list for error reporting.
 -}
autocopy attribute procName :: Decorated Name occurs on Exprs;

aspect production nilExprs
es::Exprs ::=
{
  es.errors <-
    case es.paramsKnown of
    | nothing() -> []
    | just([]) -> []
    | just(_::_) -> [err(es.procName.location, "Insufficient parameters supplied to procedure call " ++ es.procName.name)]
    end;
}


aspect production consExprs
es::Exprs ::= e::Expr rest::Exprs
{
  es.errors <- 
    case es.paramsKnown of
    | nothing()  -> []
    | just([])   -> [err(es.procName.location, "Too many parameters provided to procedure call " ++ es.procName.name)]
    | just(h::_) -> 
        checkErrors(e.type, h.snd.type, "parameter", e.location) ++
        (if h.snd.passedByValue then []
         else case e, e.evalConstInt of
              | lExpr(_), nothing() -> []
              | _, just(_) -> [err(e.location, "Procedure parameter is a VAR, but parameter " ++ pp:show(100, e.pp) ++ " is constant")]
              | _, _ -> [err(e.location, "Procedure parameter is a VAR, but parameter " ++ pp:show(100, e.pp) ++ " is not a reference")]
              end)
    end;

  rest.paramsKnown =
    case es.paramsKnown of
    | nothing() -> nothing()
    | just([]) -> nothing()
    | just(_::t) -> just(t)
    end;
}

aspect production readCall
s::Stmt ::= f::Name e::Exprs
{
  e.procName = f;
  e.paramsKnown = just([pair("zzz", decorate paramDeclReference(name("zzz", location=s.location), integerTypeExpr(location=s.location), location=s.location) with {env=s.env;})]);
}
aspect production writeCall
s::Stmt ::= f::Name e::Exprs
{
  e.procName = f;
  e.paramsKnown = just([pair("zzz", decorate paramDeclValue(name("zzz", location=s.location), integerTypeExpr(location=s.location), location=s.location) with {env=s.env;})]);
}
aspect production writeLnCall
s::Stmt ::= f::Name e::Exprs
{
  e.procName = f;
  e.paramsKnown = just([]);
}


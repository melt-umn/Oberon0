grammar edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

imports edu:umn:cs:melt:Oberon0:core;

imports silver:langutil;
imports silver:langutil:pp as pp;

exports edu:umn:cs:melt:Oberon0:constructs:procedures:typeChecking
  with edu:umn:cs:melt:Oberon0:core:typeChecking;

{--
 - Indicates what procedure contains this subtree.
 - * nothing() indicates it's directly in the Module, rather than a specific
 -   procedure.
 -}
inherited attribute enclosingProcedure :: Maybe<Decorated Decl>   --T2
  occurs on Decl, Module, Stmt;  --T2

propagate enclosingProcedure on Stmt;

abstract production procDecl
d::Decl ::= id::Name formals::Decl locals::Decl s::Stmt endid::Name
{
  --T2-start
  formals.enclosingProcedure = just(d);
  locals.enclosingProcedure = just(d);
  s.enclosingProcedure = just(d);
  d.passedByValue = error("Should never ask for this as this is not a proc decl - procDecl");
  --T2-end

  d.pp = pp:ppConcat([
    pp:text("PROCEDURE "), id.pp, pp:parens(pp:ppImplode(pp:text("; "), map((.pp), formals.individualDcls))), pp:semi(),
      pp:nestlines(2, locals.pp),
    pp:text("BEGIN"), 
      pp:nestlines(2, s.pp),
    pp:text("END "), endid.pp, pp:semi() ]);

  --T2-start  
  d.individualDcls := [d];
  propagate vars;
  d.funs <- [(id.name, d)];
  
  -- Create a scope upon entry to the function, add formals, then do into locals.
  formals.env = newScope(d.env);
  locals.env = formals.newEnv;

  -- Permit recursive calls, but not "back-recursive" (i.e. nest procs can't call this one)
  s.env = addDefs(valueDef(id.name, d), locals.newEnv);
  
  -- Only propogate out the procedure def.
  d.newEnv = addDefs(valueDef(id.name, d), d.env);
  
  d.errors := formals.errors ++ locals.errors ++ s.errors;
  
  d.errors <- 
    if id.name != endid.name
    then [err(d.location, "End statement for procedure " ++ id.name ++ " claims it ends " ++ endid.name)]
    else [];
  
  d.errors <-
    case orElse(lookupValueInScope(id.name, d.env),
                lookupTypeInScope(id.name, d.env)) of
    | just(redecl) -> 
        [err(d.location, "PROCEDURE declaration " ++ id.name ++ " is already declared at " ++ 
           redecl.location.filename ++ ":" ++ toString(redecl.location.line))]
    | _ -> []
    end;

  -- There is nothing "semantically equivalent" to forward to,
  -- and therefore this is not a "pure" extension.
  
  -- This is an unusual situation that is due to the "core" language being
  -- rather impoverished.

  --T2-end
}


aspect production seqDecl
d::Decl ::= d1::Decl d2::Decl
{
  local procs :: [Decorated Decl] = filter(isProcDcl, d.individualDcls);
--  production attribute pppieces :: String with ++; -- from seqDecl
  pppieces <- map((.pp), procs);
  propagate enclosingProcedure;
}

{--
 - Used to filter declarations down to just procedures for pretty printing purposes.
 -}
  --T2-start
fun isProcDcl Boolean ::= d::Decorated Decl =
  case d of procDecl(_,_,_,_,_) -> true | _ -> false end;
  --T2-end

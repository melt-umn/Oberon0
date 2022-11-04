grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Decl with location, pp,
   env, errors, individualDcls, vars, newEnv;  --T2

{--
 - Used to get at each Decl individually for pretty printing.
 -}
monoid attribute individualDcls :: [Decorated Decl];  --T2
{--
 - The brand new, resulting environment, modified from env.
 -}
synthesized attribute newEnv :: Decorated Env;  --T2
{--
 - Information about the variable bindings of a declaration
 -}
monoid attribute vars :: [Pair<String Decorated Decl>];  --T2

propagate vars on Decl;
propagate env on Decl excluding seqDecl;

{--
 - Lines up all decls by their left edge.
 -}
function ppDecls
pp:Document ::= pre::String dcls::[Decorated Decl]
{
  return pp:ppConcat([pp:text(pre), pp:box(pp:ppImplode(pp:cat(pp:semi(), pp:line()), map((.pp), dcls))), pp:semi()]);
}
abstract production seqDecl
d::Decl ::= d1::Decl d2::Decl
{
  d.pp = pp:ppImplode(pp:line(), pppieces);
  
  local consts :: [Decorated Decl] = filter(isConstDcl, d.individualDcls);
  local types :: [Decorated Decl] = filter(isTypeDcl, d.individualDcls);
  local vars :: [Decorated Decl] = filter(isVarsDcl, d.individualDcls);

  production attribute pppieces :: [pp:Document] with ++;
  pppieces := (if !null(consts) then [ppDecls("CONST ", consts)] else [])
           ++ (if !null(types) then [ppDecls("TYPE ", types)] else [])
           ++ (if !null(vars) then [ppDecls("VAR ", vars)] else []);
  --T2-start
  propagate individualDcls;
  
  -- Use the attributes 'env' and 'newEnv' to thread changes to the environment
  -- through the Decl block.
  d1.env = d.env;
  d2.env = d1.newEnv;
  d.newEnv = d2.newEnv;
  
  propagate errors;
  --T2-end
}

abstract production noDecl
d::Decl ::=
{
  d.pp = pp:notext();
  --T2-start
  propagate individualDcls;
  d.newEnv = d.env;
  
  propagate errors;
  --T2-end
}

abstract production constDecl
d::Decl ::= id::Name e::Expr
{
  d.pp = pp:ppConcat([id.pp, pp:text(" = "), e.pp]);

  --T2-start  
  d.individualDcls := [d];
  
  d.newEnv = addDefs(valueDef(id.name, d), d.env);
  
  d.errors := e.errors;
  
  d.errors <-
    case orElse(lookupValueInScope(id.name, d.env),
                lookupTypeInScope(id.name, d.env)) of
    | just(redecl) -> 
        [err(d.location, "CONST declaration " ++ id.name ++ " is already declared at " ++ 
           redecl.location.filename ++ ":" ++ toString(redecl.location.line))]
    | _ -> []
    end;

  d.errors <-
    if e.evalConstInt.isJust then []
    else [err(e.location, "Expression " ++ pp:show(100, e.pp) ++ " is not constant valued.")];
  --T2-end
}

abstract production typeDecl
d::Decl ::= id::TypeName t::TypeExpr
{
  d.pp = pp:ppConcat([id.pp, pp:text(" = "), t.pp]);
  --T2-start
  d.individualDcls := [d];
  
  d.newEnv = addDefs(typeDef(id.name, d), d.env);

  d.errors := t.errors;
  
  d.errors <-
    case orElse(lookupTypeInScope(id.name, d.env),
                lookupValueInScope(id.name, d.env)) of
    | just(redecl) -> 
        [err(d.location, "TYPE declaration " ++ id.name ++ " is already declared at " ++ 
           redecl.location.filename ++ ":" ++ toString(redecl.location.line))]
    | _ -> []
    end;
  --T2-end
}

abstract production varDecl
d::Decl ::= id::Name t::TypeExpr
{
  d.pp = pp:ppConcat([id.pp, pp:text(" : "), t.pp]);

  --T2-start
  d.individualDcls := [d];
  d.vars <- [pair(id.name, d)];
  
  d.newEnv = addDefs(valueDef(id.name, d), d.env);

  d.errors := t.errors;
  
  d.errors <-
    case orElse(lookupValueInScope(id.name, d.env),
                lookupTypeInScope(id.name, d.env)) of
    | just(redecl) -> 
        [err(d.location, "VAR declaration " ++ id.name ++ " is already declared at " ++ 
           redecl.location.filename ++ ":" ++ toString(redecl.location.line))]
    | _ -> []
    end;
  --T2-end
}

{--
 - Why do we not simply rewrite this away in the conversion to AST?
 - Because we'd like to be smart about error messages, if there is a problem
 - with the type. No sense in emitting dozens of messages for one error!
 - Also, so we can be accurate in pretty printing.
 -}
abstract production varDecls
d::Decl ::= ids::IdList t::TypeExpr
{
  d.pp = pp:ppConcat([ids.pp, pp:text(" : "), t.pp]);

  --T2-start
  d.individualDcls := [d];

  -- OMIT repeating the error over and over, if the type is malformed.
  d.errors := if null(t.errors)
              then forward.errors
              else t.errors;

  ids.idVarDeclTypeExpr = t;
  ids.idVarDeclProd = varDecl(_, _, location=_);
  --T2-end

  forwards to ids.idVarDecls;

  propagate env;
}


nonterminal IdList with pp, location,
  idVarDecls, idVarDeclTypeExpr, idVarDeclProd;   --T2

{--
 - Constructs a sequence of declarations from a sequence of identifiers,
 - using idVarDeclTypeExpr as the type and idVarDeclProd as the kind of
 - declaration.
 -}
synthesized attribute idVarDecls :: Decl;  --T2
{--
 - The type of each of the identifiers.
 -}
inherited attribute idVarDeclTypeExpr :: TypeExpr;  --T2
propagate idVarDeclTypeExpr on IdList;

{--
 - The kind of declaration. Here, only varDecl. But, the procedure
 - extension will also have "by value" and "by reference" decls as well.
 -}
inherited attribute idVarDeclProd :: (Decl ::= Name TypeExpr Location);  --T2
propagate idVarDeclProd on IdList;

abstract production idListOne
ids::IdList ::= id::Name
{
  ids.pp = id.pp;
  ids.idVarDecls = ids.idVarDeclProd(id, ids.idVarDeclTypeExpr, id.location);  --T2
}

abstract production idListCons
ids::IdList ::= id::Name rest::IdList
{
  ids.pp = pp:ppConcat([id.pp, pp:text(", "), rest.pp]);
  --T2-start
  ids.idVarDecls = seqDecl(ids.idVarDeclProd(id, ids.idVarDeclTypeExpr, id.location),
                           rest.idVarDecls, location=ids.location); 
  --T2-end
}


  --T2-start
function isConstDcl
Boolean ::= d::Decorated Decl
{
  return case d of constDecl(_,_) -> true | _ -> false end;
}
function isTypeDcl
Boolean ::= d::Decorated Decl
{
  return case d of typeDecl(_,_) -> true | _ -> false end;
}
function isVarsDcl
Boolean ::= d::Decorated Decl
{
  return case d of varDecl(_,_) -> true | varDecls(_,_) -> true | _ -> false end;
}
  --T2-end

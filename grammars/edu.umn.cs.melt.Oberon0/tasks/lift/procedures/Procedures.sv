grammar edu:umn:cs:melt:Oberon0:tasks:lift:procedures;

import silver:util:treemap as tm;

{--
 - The lambda-lifting solution set for a procedure.
 - 
 - Indicates the set of variables from outer scopes that this procedure
 - references.  Those that are not top-level are added to its parameter list.
 -}
synthesized attribute sol :: [Decorated Decl] occurs on Decl;

aspect production procDecl
d::Decl ::= id::Name formals::Decl ld::Decl s::Stmt endid::Name
{
  d.idNum = genInt();

  d.varRefTrans = error("Only applicable to values");

  -- An almost lambda-lifting. We do no consider declarations blocks to be recursive.
  -- (i.e. letrec) but in artifact 5 we DO allow functions to be recursive, but
  -- not mutually recursive. (i.e. it's a normal let block, not letrec, but
  -- function can still call themselves, or functions from outer scope.)
  
  -- The set of variables in the current scope, i.e. they can occur as free variables
  -- in the procedure body. (using d.env, because only those are "free")
  local vars::[Decorated Decl] = getVarDecls (d.env);
  -- the set of functions in the current scope, we already know which variables have
  -- to be abstracted out. (using s.env - self, because we should have solve children, 
  -- and we need to know the free variables of child functions)
  local funs::[Decorated Decl] = removeBy(eqDecls, d, getProcDecls (s.env));

  -- the solutions of the set equations.
  d.sol = 
    intersectBy(eqDecls, vars, 
      unionsBy(eqDecls, s.freevars :: map((.sol), intersectBy(eqDecls, funs, s.freevars))));
  -- read: Take all free variables mention in body, plus all free variables mentioned in
  -- called child procedure's sol sets, and add them.

  nondecorated local liftedId :: Name = name(d.liftedName, location=id.location);
  nondecorated local thisAsLifted::Decl = procDecl(liftedId, extendedParams(d.sol, formals.lifted), ld.lifted, s.lifted, liftedId, location=d.location);

  d.lifted = if d.enclosingProcedure.isJust
             then -- this one is lifted and inserted higher up
                  noDecl(location=d.location)   
             else -- insert lifted local procs before this one
                  foldr(seqDecl(_, _, location=d.location), thisAsLifted, ld.liftedDecls);

  d.liftedDecls = if !d.enclosingProcedure.isJust
                  then [ ]
                  else ld.liftedDecls ++ [ thisAsLifted ];


  d.liftedName = uniqueName(id.name, d.universalNamesIn);
  formals.universalNamesIn = d.liftedName :: d.universalNamesIn;
  ld.universalNamesIn = formals.universalNamesOut;
  d.universalNamesOut = ld.universalNamesOut;
}

{--
 - Adds all non-top-level variables the procedure references to
 - the parameter list, as reference parameters.
 -
 - @see extenededArgs
 -}
function extendedParams
Decl ::= toAdd::[Decorated Decl] prev::Decl
{
  return if null(toAdd) then ^prev
         else if !d.enclosingProcedure.isJust {- at top level -} then rest
         else seqDecl(liftedVarDeclToReference, rest, location=d.location);

  local d::Decorated Decl = head(toAdd);
  nondecorated local rest::Decl = extendedParams(tail(toAdd), ^prev);
  nondecorated local liftedVarDeclToReference :: Decl =
    case d.lifted of
    | varDecl(n,t) -> paramDeclReference(^n, ^t, location=d.location)
    end;
}

-- Support functions --
function getVarDecls 
[Decorated Decl] ::= en::Env
{
  return filter(isVarDecl, map(getDecl, bindings));

  local bindings::[Pair<String Decorated Decl>] =
    concat(map(get_bindings, en.values));
}

function getProcDecls 
[Decorated Decl] ::= en::Env
{
  return filter(isProcDecl, map(getDecl, bindings));

  local bindings::[Pair<String Decorated Decl>] =
    concat(map(get_bindings, en.values));
}

function get_bindings
[Pair<a b>] ::= sm::tm:Map<a b>
{
  return tm:toList(sm);
}

function isVarDecl
Boolean ::= d::Decorated Decl
{
  return !isProcDecl(d);
}

function isProcDecl
Boolean ::= d::Decorated Decl
{
  return case d of
         | procDecl(_,_,_,_,_) -> true
         | _ -> false
         end;
}

function getDecl
Decorated Decl ::= p::Pair<String Decorated Decl>
{
  return p.snd;
}

function concat
[a]::= ss::[[a]]
{
  return foldr (append, [ ], ss);
}


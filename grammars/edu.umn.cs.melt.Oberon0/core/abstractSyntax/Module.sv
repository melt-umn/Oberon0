grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Module with location, pp,
  errors; --T2

abstract production module
m::Module ::= id::Name ds::Decl ss::Stmt endid::Name 
{
  m.pp = pp:ppConcat([
    pp:text("MODULE "), id.pp, pp:semi(),
      pp:nestlines(2, ds.pp),
    pp:text("BEGIN"), 
      pp:nestlines(2, ss.pp),
    pp:text("END "), endid.pp, pp:text("."), pp:line() ]);

 --T2-start  
  ds.env = initialGlobalScope;
  ss.env = ds.newEnv;
  
  m.errors := ds.errors ++ ss.errors;
  
  m.errors <- if id.name != endid.name
              then [err(endid.location, "Mismatching END statements. Module " ++ id.name ++ " ended with " ++ endid.name)]
              else [];
  
  production attribute initialGlobalScope :: Env;
  initialGlobalScope = newScope(addDefs(foldr(appendDefs, noDefs(), [
     aprioriTypeDecl("BOOLEAN", booleanTypeExpr(location=aprioriLoc)),
     aprioriTypeDecl("INTEGER", integerTypeExpr(location=aprioriLoc)),
     aprioriConstDecl("TRUE", eqOp(error("not needed"), error("not needed"), location=aprioriLoc)),
     aprioriConstDecl("FALSE", eqOp(error("not needed"), error("not needed"), location=aprioriLoc))]),
    emptyEnv()));
 --T2-end
}

global aprioriLoc :: Location = loc("<PRELUDE>", -1, -1, -1, -1, -1, -1); --T2

{--
 - This function exists for two reasons:
 - 1. It's abstracting away dealing with faking the declarations
 - 2. The production attribute is important, as we might need
 -    to tack on faked inherited attributes to our faked decl in
 -    extensions. See tasks/codegenC/core/Module.sv
 -}
 --T2-start
function aprioriTypeDecl
Defs ::= n::String  t::TypeExpr
{
  production attribute fakedDecl :: Decl;
  fakedDecl = typeDecl(typeName(n, location=aprioriLoc), @t, location=aprioriLoc);
  fakedDecl.env = emptyEnv();  

  return typeDef(n, fakedDecl);
}

function aprioriConstDecl
Defs ::= n::String  e::Expr
{
  production attribute fakedDecl :: Decl;
  fakedDecl = constDecl(name(n, location=aprioriLoc), @e, location=aprioriLoc);
  fakedDecl.env = emptyEnv();  
  
  return valueDef(n, fakedDecl);
}
 --T2-end

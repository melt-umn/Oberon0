grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

import edu:umn:cs:melt:Oberon0:core:typeChecking; -- need type!
import edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax only enclosingProcedure;

attribute varRefTrans,
          lifted<Decl>, liftedDecls, 
          liftedName, idNum,
          universalNamesOut, universalNamesIn occurs on Decl;

{--
 - We make every name unique using universalNamesOut/In.
 - This is the new, unique name for this Decl.
 - Typically obtained via reference attribute to this Decl.
 -}
synthesized attribute liftedName :: String;

{--
 - Not terribly good style, but the 'genInt' backdoor to side-effects allows
 - us to created an "object identity" for Decorated types.
 -
 - This will be unique for every Decorated Decl, letting us to check if they're
 - the same.  Not the best approach, but quick and dirty.
 -}
synthesized attribute idNum :: Integer;

{--
 - How should this variable be referred to in an expression.
 - Used primarily to permit dereferencing on procedure parameters passed by
 - reference.
 -
 - Should only be on declarations that can be referenced in expressions.
 -}
synthesized attribute varRefTrans :: String;


aspect production seqDecl
d::Decl ::= d1::Decl d2::Decl
{
  d.lifted = seqDecl(d1.lifted, d2.lifted, location=d.location);
  d.liftedDecls = d1.liftedDecls ++ d2.liftedDecls;
  
  d.liftedName = error("Not applicable to sequences");
  d.idNum = error("Not applicable to sequences");
  d.varRefTrans = error("Only applicable to values");
  
  d1.universalNamesIn = d.universalNamesIn;
  d2.universalNamesIn = d1.universalNamesOut;
  d.universalNamesOut = d2.universalNamesOut;
}

aspect production noDecl
d::Decl ::=
{
  d.lifted = d;
  d.liftedDecls = [];

  d.liftedName = error("Not applicable to sequences");
  d.idNum = error("Not applicable to sequences");
  d.varRefTrans = error("Only applicable to values");
  
  d.universalNamesOut = d.universalNamesIn;
}

aspect production constDecl
d::Decl ::= id::Name e::Expr
{
  d.varRefTrans = id.name;
  d.idNum = genInt();
  
  d.lifted = if !d.enclosingProcedure.isJust then lifted else noDecl(location=d.location);
  d.liftedDecls = if !d.enclosingProcedure.isJust then [] else [lifted];
  
  local lifted :: Decl = constDecl(name(d.liftedName, location=id.location), e, location=d.location);
  
  d.liftedName = uniqueName(id.name, d.universalNamesIn);
  d.universalNamesOut = d.liftedName :: d.universalNamesIn;
}

aspect production typeDecl
d::Decl ::= id::TypeName t::TypeExpr
{ 
  d.idNum = genInt();
  d.varRefTrans = error("Only applicable to values");
  
  d.lifted = if !d.enclosingProcedure.isJust then lifted else noDecl(location=d.location);
  d.liftedDecls = if !d.enclosingProcedure.isJust then [] else [lifted];
  
  local lifted :: Decl = typeDecl(typeName(d.liftedName, location=id.location), t.lifted, location=d.location);
  
  d.liftedName = uniqueName(id.name, d.universalNamesIn);
  d.universalNamesOut = d.liftedName :: d.universalNamesIn;
}

aspect production varDecl
d::Decl ::= id::Name t::TypeExpr
{
  d.varRefTrans = id.name;
  d.idNum = genInt();
  
  d.lifted = varDecl(name(d.liftedName, location=id.location), t.lifted, location=d.location);
  d.liftedDecls = [];
  
  d.liftedName = uniqueName(id.name, d.universalNamesIn);
  d.universalNamesOut = d.liftedName :: d.universalNamesIn;
}


{--
 - (Ab)uses the idNum attribute to determine if the two Decorated Decl
 - arguments are the same Decorated Decl.
 -}
function eqDecls
Boolean ::= a::Decorated Decl  b::Decorated Decl
{
  return a.idNum == b.idNum;
}

{--
 - Returns a unique name, given a set of used names.
 -
 - @param start  The initial name.
 - @param un  The set of already reserved names.
 - @return  A new name, not in the 'un' set.
 -}
function uniqueName
String ::= start::String un::[String]
{
  return if contains(start, un)
         then uniqueName(start ++ "ZZ" ++ toString(genInt()), un)
         else start;
}


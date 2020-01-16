grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

import edu:umn:cs:melt:Oberon0:core:typeChecking; -- need type!
import edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax only enclosingProcedure;

attribute cTrans occurs on Decl;

aspect production seqDecl
d::Decl ::= d1::Decl d2::Decl
{
  d.cTrans = d1.cTrans ++ d2.cTrans;
}

aspect production noDecl
d::Decl ::=
{
  d.cTrans = "";
}

aspect production constDecl
d::Decl ::= id::Name e::Expr
{
  -- Should only appear at top level.
  d.cTrans = "#define " ++ id.name ++ " (" ++ e.cTrans ++ ")\n";
}

aspect production typeDecl
d::Decl ::= id::TypeName t::TypeExpr
{ 
  -- Should only appear at top level.
  d.cTrans = "typedef " ++ t.cTrans ++ " " ++ id.name ++ t.cTransSuffix ++ "; \n";

}

aspect production varDecl
d::Decl ::= id::Name t::TypeExpr
{
  d.cTrans = t.cTrans ++ " " ++ id.name ++ t.cTransSuffix ++ ";\n";
}


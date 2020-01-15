grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:procedures;

{--
 - Translation specifically for parameters. Exists primarily because
 - it's separated by commas in C, rather than semicolons. :)
 -
 - Note: We ignore 'cTransSuffix' on TypeExpr here because it should be 
 - irrelevant: it's not legal to put array types directly in parameter lists.
 -}
synthesized attribute cParamTrans :: String occurs on Decl;

-- lifted for parameters JUST does renaming... nothing moves out!

aspect production paramDeclValue
d::Decl ::= id::Name t::TypeExpr
{
  d.cParamTrans = t.cTrans ++ " " ++ id.name;
}

aspect production paramDeclReference
d::Decl ::= id::Name t::TypeExpr
{
  d.cParamTrans = t.cTrans ++ " *" ++ id.name;
}


grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:procedures;

import silver:util:treemap;

aspect production procDecl
d::Decl ::= id::Name formals::Decl ld::Decl s::Stmt endid::Name
{
  d.cTrans = "void " ++ id.name ++ "(" ++ implode(", ", map((.cParamTrans), formals.individualDcls)) ++ ")\n{\n" ++ ld.cTrans ++ s.cTrans ++ "}\n";
}


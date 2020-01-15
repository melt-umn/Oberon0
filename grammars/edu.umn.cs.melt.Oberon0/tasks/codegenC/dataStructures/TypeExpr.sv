grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:dataStructures;

aspect production arrayTypeExpr
t::TypeExpr ::= e::Expr ty::TypeExpr
{
  t.cTrans = ty.cTrans;
  t.cTransSuffix = "[" ++ e.cTrans ++ "]" ++ ty.cTransSuffix;
}

aspect production recordTypeExpr
t::TypeExpr ::= f::Decl
{
  t.cTrans = "struct {" ++ f.cTrans ++ "}";
  t.cTransSuffix = "";
}


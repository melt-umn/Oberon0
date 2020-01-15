grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:dataStructures;

aspect production arrayAccess
e::LExpr ::= array::LExpr index::Expr
{
  e.cTrans = array.cTrans ++ "[" ++ index.cTrans ++ "]";
}

aspect production fieldAccess
e::LExpr ::= rec::LExpr fld::Name
{
  e.cTrans = rec.cTrans ++ "." ++ fld.name;
}


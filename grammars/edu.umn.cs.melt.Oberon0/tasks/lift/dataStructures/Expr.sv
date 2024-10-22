grammar edu:umn:cs:melt:Oberon0:tasks:lift:dataStructures;

aspect production arrayAccess
e::LExpr ::= array::LExpr index::Expr
{
  e.freevars = array.freevars ++ index.freevars;
  e.lifted = arrayAccess(array.lifted, index.lifted, location=e.location);
}

aspect production fieldAccess
e::LExpr ::= rec::LExpr fld::Name
{
  e.freevars = rec.freevars;
  e.lifted = fieldAccess(rec.lifted, ^fld, location=e.location); -- no renaming done on field names
}


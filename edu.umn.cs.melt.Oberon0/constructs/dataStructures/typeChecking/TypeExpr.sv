grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking;

aspect production arrayTypeExpr
t::TypeExpr ::= e::Expr ty::TypeExpr
{
  t.type = arrayType(e, ty.type, genInt());

  t.errors <- if !check(e.type, integerType())
              then [err(e.location, "Array must have an INTEGER size")]
              else [];
  t.errors <- case e.evalConstInt of
              | nothing() -> [err(e.location, "Array type must have constant size")]
              | just(x) -> if x < 0
                           then [err(e.location, "Array cannot have negative size")]
                           else []
              end;
}

aspect production recordTypeExpr
t::TypeExpr ::= f::Decl
{
  t.type = recordType(f, genInt());
}

{- genInt() is used to simply generate an integer that's unique for this session.
   See the comment in the 'check' function in TypeRep.sv in this grammar for more
   details -}


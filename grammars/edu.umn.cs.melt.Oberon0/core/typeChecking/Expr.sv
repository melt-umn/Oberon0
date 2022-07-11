grammar edu:umn:cs:melt:Oberon0:core:typeChecking;

attribute type occurs on Expr, LExpr;

aspect production idAccess
e::LExpr ::= id::Name
{
  e.type = case id.lookupName of
           | just(dcl1) -> dcl1.type
           | _ -> errorType()
           end;
}

aspect production lExpr
e::Expr ::= l::LExpr
{
  e.type = l.type;
}

aspect production number
e::Expr ::= n::String
{
  e.type = integerType();
}

aspect production mulOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = integerType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to *", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to *", e2.location);
}

aspect production divOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = integerType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to DIV", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to DIV", e2.location);
}

aspect production modOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = integerType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to MOD", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to MOD", e2.location);
}

aspect production addOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = integerType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to +", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to +", e2.location);
}

aspect production subOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = integerType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to -", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to -", e2.location);
}

aspect production notOp
e::Expr ::= e1::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, booleanType(), "Operand to ~", e1.location);
}

aspect production andOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, booleanType(), "First operand to &", e1.location);
  e.errors <- checkErrors(e2.type, booleanType(), "Second operand to &", e2.location);
}

aspect production orOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, booleanType(), "First operand to OR", e1.location);
  e.errors <- checkErrors(e2.type, booleanType(), "Second operand to OR", e2.location);
}

aspect production eqOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- if check(e1.type, e2.type) then []
              else [err(e.location, "Operands to equality operator are not the same type: " ++ pp:show(100, e1.type.pp) ++ " and " ++ pp:show(100, e2.type.pp))];
  e.errors <- if check(e2.type, integerType()) then []
              else [err(e.location, "Operand to equality must be INTEGER, instead it is " ++ pp:show(100, e2.type.pp))];
}

aspect production neqOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- if check(e1.type, e2.type) then []
              else [err(e.location, "Operands to inequality operator are not the same type: " ++ pp:show(100, e1.type.pp) ++ " and " ++ pp:show(100, e2.type.pp))];
  e.errors <- if check(e2.type, integerType()) then []
              else [err(e.location, "Operand to inequality must be INTEGER, instead it is " ++ pp:show(100, e2.type.pp))];
}

aspect production ltOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to <", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to <", e2.location);
}

aspect production gtOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to >", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to >", e2.location);
}

aspect production lteOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to <=", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to <=", e2.location);
}

aspect production gteOp
e::Expr ::= e1::Expr e2::Expr
{
  e.type = booleanType();

  e.errors <- checkErrors(e1.type, integerType(), "First operand to >=", e1.location);
  e.errors <- checkErrors(e2.type, integerType(), "Second operand to >=", e2.location);
}


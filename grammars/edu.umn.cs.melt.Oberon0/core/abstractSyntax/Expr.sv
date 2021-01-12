grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Expr with location, pp,
  env, errors, evalConstInt;   --T2
nonterminal LExpr with location, pp,
  env, errors, evalConstInt;  --T2

{--
 - Evaluates constant integer expressions.
 -   nothing() represents a non-constant (or other error) expression.
 -
 - Used to both check whether an expression is constant, as well as see
 - what value it has. To, for example, check static array access.
 -}
synthesized attribute evalConstInt :: Maybe<Integer>;  --T2

propagate errors on Expr, LExpr;  -- T2

abstract production idAccess
e::LExpr ::= id::Name
{
  e.pp = id.pp;

  --T2-start
  e.evalConstInt = case id.lookupName of
                   | just(constDecl(_,fe)) -> fe.evalConstInt
                   | _ -> nothing()
                   end;
  --T2-end
}

abstract production lExpr
e::Expr ::= l::LExpr
{
  e.pp = l.pp;
  
  e.evalConstInt = l.evalConstInt;  --T2
}

abstract production number
e::Expr ::= n::String
{
  e.pp = pp:text(n);
  
  e.errors <- if toIntSafe(n).isJust then []  --T2
              else [err(e.location, n ++ " is not a valid number." ++ --T2
                    " Probably out of range.")];  --T2
  e.evalConstInt = toIntSafe(n);  --T2
}

-- Numerical

abstract production mult
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" * "), e2.pp]));

  --T2-start
  e.evalConstInt = case e1.evalConstInt, e2.evalConstInt of
                   | just(x), just(y) -> just(x * y)
                   | _, _ -> nothing()
                   end;
  --T2-end
}

abstract production div
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" DIV "), e2.pp]));

  --T2-start
  e.evalConstInt = case e1.evalConstInt, e2.evalConstInt of
                   | just(x), just(0) -> nothing()
                   | just(x), just(y) -> just(x / y)
                   | _, _ -> nothing()
                   end;
  --T2-end
}

abstract production mod
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" MOD "), e2.pp]));

  --T2-start
  e.evalConstInt = case e1.evalConstInt, e2.evalConstInt of
                   | just(x), just(0) -> nothing()
                   | just(x), just(y) -> just(x % y)
                   | _, _ -> nothing()
                   end;
  --T2-end
}

abstract production add
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" + "), e2.pp]));
  
  --T2-start
  e.evalConstInt = case e1.evalConstInt, e2.evalConstInt of
                   | just(x), just(y) -> just(x + y)
                   | _, _ -> nothing()
                   end;
  --T2-end
}

abstract production sub
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" - "), e2.pp]));
  
  --T2-start
  e.evalConstInt = case e1.evalConstInt, e2.evalConstInt of
                   | just(x), just(y) -> just(x - y)
                   | _, _ -> nothing()
                   end;
  --T2-end
}

-- Boolean

abstract production not
e::Expr ::= e1::Expr
{
  e.pp = (pp:ppConcat([pp:text("~"), e1.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production and
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" & "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production or
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" OR "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

-- Comparison

abstract production eqOp
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" = "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production neqOp
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" # "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production ltOp
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" < "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production gtOp
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" > "), e2.pp]));

  e.evalConstInt = nothing();  --T2
}

abstract production ltOpe
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" <= "), e2.pp]));

  e.evalConstInt = nothing(); --T2
}

abstract production gtOpe
e::Expr ::= e1::Expr e2::Expr
{
  e.pp = pp:parens(pp:ppConcat([e1.pp, pp:text(" >= "), e2.pp]));

  e.evalConstInt = nothing(); --T2
}


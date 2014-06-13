grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

closed nonterminal Expr_c with ast<Expr>, location;

concrete productions e::Expr_c
 | id::Name_c         { e.ast = lExpr(idAccess(id.ast, location=e.location), location=e.location); }
 | n::Num_t           { e.ast = number(n.lexeme, location=e.location); }
 | '(' e1::Expr_c ')' { e.ast = e1.ast; }

-- Numerical
 | e1::Expr_c '*' e2::Expr_c    { e.ast = mult(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'DIV' e2::Expr_c  { e.ast = div(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'MOD' e2::Expr_c  { e.ast = mod(e1.ast, e2.ast, location=e.location); }
 | '+' e1::Expr_c               { e.ast = e1.ast; }
 | '-' e1::Expr_c               { e.ast = sub(number("0", location=$1.location), e1.ast, location=e.location); }
 | e1::Expr_c '+' e2::Expr_c    { e.ast = add(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '-' e2::Expr_c    { e.ast = sub(e1.ast, e2.ast, location=e.location); }

-- Boolean
 | '~' e1::Expr_c               { e.ast = not(e1.ast, location=e.location); }
 | e1::Expr_c '&' e2::Expr_c    { e.ast = and(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'OR' e2::Expr_c   { e.ast = or(e1.ast, e2.ast, location=e.location); }

-- Comparison
 | e1::Expr_c '=' e2::Expr_c    { e.ast = eq(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '#' e2::Expr_c    { e.ast = neq(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '<' e2::Expr_c    { e.ast = lt(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '>' e2::Expr_c    { e.ast = gt(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '<=' e2::Expr_c   { e.ast = lte(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '>=' e2::Expr_c   { e.ast = gte(e1.ast, e2.ast, location=e.location); }


grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

closed nonterminal Expr_c with ast<Expr>, location;

concrete productions e::Expr_c
 | id::Name_c         { e.ast = lExpr(idAccess(id.ast, location=e.location), location=e.location); }
 | n::Num_t           { e.ast = number(n.lexeme, location=e.location); }
 | '(' e1::Expr_c ')' { e.ast = e1.ast; }

-- Numerical
 | e1::Expr_c '*' e2::Expr_c    { e.ast = mulOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'DIV' e2::Expr_c  { e.ast = divOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'MOD' e2::Expr_c  { e.ast = modOp(e1.ast, e2.ast, location=e.location); }
 | '+' e1::Expr_c               { e.ast = e1.ast; }
 | '-' e1::Expr_c               { e.ast = subOp(number("0", location=$1.location), e1.ast, location=e.location); }
 | e1::Expr_c '+' e2::Expr_c    { e.ast = addOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '-' e2::Expr_c    { e.ast = subOp(e1.ast, e2.ast, location=e.location); }

-- Boolean
 | '~' e1::Expr_c               { e.ast = notOp(e1.ast, location=e.location); }
 | e1::Expr_c '&' e2::Expr_c    { e.ast = andOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c 'OR' e2::Expr_c   { e.ast = orOp(e1.ast, e2.ast, location=e.location); }

-- Comparison
 | e1::Expr_c '=' e2::Expr_c    { e.ast = eqOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '#' e2::Expr_c    { e.ast = neqOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '<' e2::Expr_c    { e.ast = ltOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '>' e2::Expr_c    { e.ast = gtOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '<=' e2::Expr_c   { e.ast = lteOp(e1.ast, e2.ast, location=e.location); }
 | e1::Expr_c '>=' e2::Expr_c   { e.ast = gteOp(e1.ast, e2.ast, location=e.location); }


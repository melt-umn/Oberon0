grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

{--
 - A list of statements
 -}
closed nonterminal Stmts_c with ast<Stmt>, location;

concrete productions s::Stmts_c
 | h::Stmt_c                 { s.ast = h.ast; }
 | h::Stmt_c ';' t::Stmts_c  { s.ast = seqStmt(h.ast, t.ast, location=s.location); }

{--
 - A statement
 -}
closed nonterminal Stmt_c with ast<Stmt>, location;

concrete productions s::Stmt_c
 | { s.ast = skip(location=s.location); }
 | id::Name_c ':=' e::Expr_c                          { s.ast = assign(idAccess(id.ast, location=id.location), e.ast, location=s.location); }
 | 'WHILE' e::Expr_c 'DO' ss::Stmts_c 'END'           { s.ast = while(e.ast, ss.ast, location=s.location); }
 | 'IF' c::Expr_c 'THEN' t::Stmts_c es::Elsifs 'END'  { s.ast = cond(c.ast, t.ast, es.ast, location=s.location); }

{--
 - Optional number of Else-ifs or Else clauses
 -}
closed nonterminal Elsifs with ast<Stmt>, location;

concrete productions s::Elsifs
 |                                                 { s.ast = skip(location=s.location); }
 | 'ELSE' ss::Stmts_c                              { s.ast = ss.ast; }
 | 'ELSIF' e::Expr_c 'THEN' ss::Stmts_c t::Elsifs  { s.ast = cond(e.ast, ss.ast, t.ast, location=s.location); }


grammar edu:umn:cs:melt:Oberon0:constructs:procedures:concreteSyntax;

concrete productions s::Stmt_c 
 | id::Name_c p::MaybeArguments  { s.ast = callDispatch(id.ast, p.ast, location=s.location); }

{--
 - Optional arguments passed in proc calls
 -}
closed nonterminal MaybeArguments with ast<Exprs>, location;

concrete productions a::MaybeArguments
 |                       { a.ast = nilExprs(location=a.location); }
 | '(' v::Arguments ')'  { a.ast = v.ast; }
 | '(' ')'               { a.ast = nilExprs(location=a.location); }

{--
 - proc call arguments
 -}
closed nonterminal Arguments with ast<Exprs>, location;

concrete productions a::Arguments
 | h::Expr_c                   { a.ast = consExprs(h.ast, nilExprs(location=a.location), location=a.location); }
 | h::Expr_c ',' t::Arguments  { a.ast = consExprs(h.ast, t.ast, location=a.location); }



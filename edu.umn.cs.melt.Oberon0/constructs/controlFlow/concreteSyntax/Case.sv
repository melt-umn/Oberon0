grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:concreteSyntax;

-- We allow all of the specified terms even though some seem not so useful.

concrete productions s::Stmt_c
 | 'CASE' e::Expr_c 'OF' cs::Cases_c 'END' { s.ast = caseStmt(e.ast, cs.ast, location=s.location); }

closed nonterminal Cases_c with ast<Cases>, location;

concrete productions cs::Cases_c
 | c::Case_c oe::OptElse_c     { cs.ast = case oe of
                                 | caseElseNone()     -> caseOne(c.ast, location=cs.location)
                                 | caseElseSome(_, s) -> caseCons(c.ast, caseOne(caseElse(s.ast, location=s.location), location=s.location), location=cs.location)
                                 end; }
 | c::Case_c '|' rest::Cases_c { cs.ast = caseCons(c.ast, rest.ast, location=cs.location); }

closed nonterminal OptElse_c with location;

concrete productions oe::OptElse_c
 (caseElseNone) | {}
 (caseElseSome) | 'ELSE' s::Stmts_c {}

closed nonterminal Case_c with ast<Case>, location;

concrete productions c::Case_c 
 | cls::CaseLabels_c ':' s::Stmts_c { c.ast = caseClause(cls.ast, s.ast, location=c.location); }

closed nonterminal CaseLabels_c with ast<CaseLabels>, location;

concrete productions cls::CaseLabels_c
 | cl::CaseLabel_c { cls.ast = oneCaseLabel(cl.ast, location=cls.location); }
 | cl::CaseLabel_c ',' rest::CaseLabels_c { cls.ast = consCaseLabel(cl.ast, rest.ast, location=cls.location); }

closed nonterminal CaseLabel_c with ast<CaseLabel>, location;

concrete productions cl::CaseLabel_c
 | e::Expr_c { cl.ast = caseLabel(e.ast, location=cl.location); }
 | l::Expr_c '..' u::Expr_c { cl.ast = caseLabelRange(l.ast, u.ast, location=cl.location); }


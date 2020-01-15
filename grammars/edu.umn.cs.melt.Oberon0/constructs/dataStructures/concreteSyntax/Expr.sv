grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:concreteSyntax;

imports edu:umn:cs:melt:Oberon0:core;
imports edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

imports silver:langutil only ast;


concrete productions e::Expr_c
 | id::Name_c s::Selectors  { s.selectingOn = idAccess(id.ast, location=id.location);
                              e.ast = lExpr(s.ast, location=e.location); }


closed nonterminal Selectors with selectingOn, ast<LExpr>, location;
closed nonterminal Selector with selectingOn, ast<LExpr>, location;

{--
 - Used to construct ast for a Selector.  Needed because the way the concrete
 - syntax specifies selectors is quite different from what we'd like in the
 - abstract syntax.
 -}
inherited attribute selectingOn :: LExpr;

concrete productions s::Selectors
 | h::Selector               { h.selectingOn = s.selectingOn;
                               s.ast = h.ast; }
 | h::Selector t::Selectors  { h.selectingOn = s.selectingOn;
                               t.selectingOn = h.ast;
                               s.ast = t.ast; }

concrete productions s::Selector
 | '[' index::Expr_c ']'  { s.ast = arrayAccess(s.selectingOn, index.ast, location=s.location); }
 | '.' id::Name_c         { s.ast = fieldAccess(s.selectingOn, id.ast, location=s.location); }


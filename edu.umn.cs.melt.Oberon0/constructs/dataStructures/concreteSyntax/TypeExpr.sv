grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:concreteSyntax;

concrete productions t::TypeExpr_c
 | 'ARRAY' e::Expr_c 'OF' ty::TypeExpr_c  { t.ast = arrayTypeExpr(e.ast, ty.ast, location=t.location); }
 | 'RECORD' f::Fields_c 'END'             { t.ast = recordTypeExpr(f.ast, location=t.location); }

{--
 - A list of record fields
 -}
closed nonterminal Fields_c with ast<Decl>, location;

concrete productions f::Fields_c
 | h::Field_c                  { f.ast = h.ast; }
 | h::Field_c ';' t::Fields_c  { f.ast = seqDecl(h.ast, t.ast, location=f.location); }

{--
 - A field of a record
 -}
closed nonterminal Field_c with ast<Decl>, location;

concrete productions f::Field_c 
 |                               { f.ast = noDecl(location=f.location); }
 | is::Idents ':' t::TypeExpr_c  { f.ast = varDecls(is.ast, t.ast, location=f.location); }


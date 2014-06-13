grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

closed nonterminal Module_c with ast<Module>, location;

concrete productions m::Module_c
 | 'MODULE' id1::Name_c ';' ds::Decls_c
   'BEGIN' ss::Stmts_c 'END' id2::Name_c '.'                   { m.ast = module(id1.ast, ds.ast, ss.ast, id2.ast, location=m.location); }
 | 'MODULE' id1::Name_c ';' ds::Decls_c 'END' id2::Name_c '.'  { m.ast = module(id1.ast, ds.ast, skip(location=$5.location), id2.ast, location=m.location); }


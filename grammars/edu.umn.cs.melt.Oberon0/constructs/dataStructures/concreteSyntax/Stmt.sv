grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:concreteSyntax;

concrete productions s::Stmt_c
 | id::Name_c sel::Selectors ':=' e::Expr_c  { sel.selectingOn = idAccess(id.ast, location=id.location);
                                               s.ast = assign(sel.ast, e.ast, location=s.location); }




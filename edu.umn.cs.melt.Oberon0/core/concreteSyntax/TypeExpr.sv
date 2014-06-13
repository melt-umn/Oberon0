grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

closed nonterminal TypeExpr_c with ast<TypeExpr>, location;

concrete productions t::TypeExpr_c
 | id::TypeName_c  { t.ast = nominalTypeExpr(id.ast, location=t.location); }

{- INTEGER and BOOLEAN are taken care of by adding them to the initial environment.
   They are not keywords. -}


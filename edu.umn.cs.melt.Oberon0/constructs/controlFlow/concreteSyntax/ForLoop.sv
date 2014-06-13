grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:concreteSyntax;

imports edu:umn:cs:melt:Oberon0:core; 
imports edu:umn:cs:melt:Oberon0:constructs:controlFlow:abstractSyntax;

imports silver:langutil only ast;

concrete productions s::Stmt_c
 | 'FOR' id::Name_c ':=' lower::Expr_c 'TO' upper::Expr_c
                    'BY' step::Expr_c 'DO' body::Stmts_c 'END'  { s.ast = forStmtBy(id.ast, lower.ast, upper.ast, step.ast, body.ast, location=s.location); }
 | 'FOR' id::Name_c ':=' lower::Expr_c 'TO' upper::Expr_c
                    'DO' body::Stmts_c 'END'                    { s.ast = forStmt(id.ast, lower.ast, upper.ast, body.ast, location=s.location); }

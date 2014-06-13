grammar edu:umn:cs:melt:Oberon0:constructs:procedures:concreteSyntax;

concrete productions d::Decls_c
 | cs::MaybeConstDcl ts::MaybeTypeDcl vs::MaybeVarDcl ps::ProcedureDcls
     { d.ast = seqDecl( seqDecl(cs.ast, ts.ast, location=d.location), seqDecl(vs.ast, ps.ast, location=d.location), location=d.location); }  


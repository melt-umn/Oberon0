grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking;


aspect production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.errors <- case l.type of
              | arrayType(_,_,_) -> [err(s.location, "Cannot assign arrays")]
              | recordType(_,_) -> [err(s.location, "Cannot assign records")]
              | _ -> []
              end;
}


grammar edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

aspect production module
m::Module ::= id::Name ds::Decl ss::Stmt endid::Name
{
  ds.enclosingProcedure = nothing();
  ss.enclosingProcedure = nothing();
}


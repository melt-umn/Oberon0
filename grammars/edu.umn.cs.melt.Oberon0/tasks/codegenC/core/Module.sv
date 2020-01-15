grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

attribute cTrans occurs on Module;

aspect production module
m::Module ::= id::Name ds::Decl ss::Stmt endid::Name
{

  {- Note that the component T5 computes the lifted tree and then
     queries that for its cTrans attribute.  Without noting this, the
     specifications below may be misunderstood as defining the cTrans
     attribute on tress that have not had nested procedures lifted to
     the top level.
   -}
  m.cTrans = 
    "#include <stdio.h>\n#define TRUE 1\n#define FALSE 0\ntypedef int INTEGER, BOOLEAN;\n\n" ++ 
    ds.cTrans ++
    "int main() {\n" ++
    ss.cTrans ++
    "}\n";

}

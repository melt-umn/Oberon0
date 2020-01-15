grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

attribute lifted<Module> occurs on Module;

aspect production module
m::Module ::= id::Name ds::Decl ss::Stmt endid::Name
{

  {- Note that the component T5 computes the lifted tree and then
     queries that for its cTrans attribute.  Without noting this, the
     specifications below may be misunderstood as defining the cTrans
     attribute on tress that have not had nested procedures lifted to
     the top level.
   -}

  m.lifted = module(id, ds.lifted, ss.lifted, endid, location=m.location);
  
  -- Reserve C keywords before we even begin. Makes translation easy-peasy!
  ds.universalNamesIn = ["auto", "break", "case", "char", "const", "continue",
    "default", "do", "double", "else", "enum", "extern", "float", "for",
    "goto", "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union", "unsigned",
    "void", "volatile", "while",
  -- Also, ensure our keywords are already used
    "INTEGER", "BOOLEAN", "TRUE", "FALSE"];
}

aspect function aprioriTypeDecl
Defs ::= n::String  t::TypeExpr
{
  fakedDecl.universalNamesIn = []; -- No renaming needed for these!
}

aspect function aprioriConstDecl
Defs ::= n::String  e::Expr
{
  fakedDecl.universalNamesIn = []; -- No renaming needed for these!
}


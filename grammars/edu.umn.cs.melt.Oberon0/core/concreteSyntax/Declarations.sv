grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

{--
 - The declarations that appear in module and procedure definitions
 -}
closed nonterminal Decls_c with ast<Decl>, location;

concrete productions d::Decls_c
 | cs::MaybeConstDcl ts::MaybeTypeDcl vs::MaybeVarDcl  { d.ast = seqDecl( seqDecl(cs.ast, ts.ast, location=d.location), vs.ast, location=d.location ); }

------------------------------------------------------------------------ CONST

{--
 - Optional constant declarations
 -}
closed nonterminal MaybeConstDcl with ast<Decl>, location;

concrete productions d::MaybeConstDcl
 |                     { d.ast = noDecl(location=d.location); }
 | 'CONST'             { d.ast = noDecl(location=d.location); }
 | 'CONST' cs::Consts  { d.ast = cs.ast; }

{--
 - A list of constant initializers
 -}
closed nonterminal Consts with ast<Decl>, location;

concrete productions d::Consts
 | h::Const            { d.ast = h.ast; }
 | h::Const t::Consts  { d.ast = seqDecl(h.ast, t.ast, location=d.location); }

{--
 - One constant initializer
 -}
closed nonterminal Const with ast<Decl>, location;

concrete productions d::Const 
 | id::Name_c '=' e::Expr_c ';'  { d.ast = constDecl(id.ast, e.ast, location=d.location); }

------------------------------------------------------------------------ TYPE

{--
 - Optional type declarations
 -}
closed nonterminal MaybeTypeDcl with ast<Decl>, location;

concrete productions d::MaybeTypeDcl
 |                      { d.ast = noDecl(location=d.location); }
 | 'TYPE'               { d.ast = noDecl(location=d.location); }
 | 'TYPE' ts::TypeDcls  { d.ast = ts.ast; }

{--
 - A list of type declarations
 -}
closed nonterminal TypeDcls with ast<Decl>, location;

concrete productions d::TypeDcls 
 | h::TypeDcl              { d.ast = h.ast; }
 | h::TypeDcl t::TypeDcls  { d.ast = seqDecl(h.ast, t.ast, location=d.location); }

{--
 - One type declaration
 -}
closed nonterminal TypeDcl with ast<Decl>, location;

concrete productions d::TypeDcl 
 | id::TypeName_c '=' e::TypeExpr_c ';'  { d.ast = typeDecl(id.ast, e.ast, location=d.location); }

------------------------------------------------------------------------ VAR

{--
 - Optional variable declarations
 -}
closed nonterminal MaybeVarDcl with ast<Decl>, location;

concrete productions d::MaybeVarDcl
 |                    { d.ast = noDecl(location=d.location); }
 | 'VAR'              { d.ast = noDecl(location=d.location); }
 | 'VAR' vs::VarDcls  { d.ast = vs.ast; }

{--
 - A List of variable declarations
 -}
closed nonterminal VarDcls with ast<Decl>, location;

concrete productions d::VarDcls
 | h::VarDcl             { d.ast = h.ast; }
 | h::VarDcl t::VarDcls  { d.ast = seqDecl(h.ast, t.ast, location=d.location); }

{--
 - One (type) of variable declarations
 -}
closed nonterminal VarDcl with ast<Decl>, location;

concrete productions d::VarDcl
 | id::Idents ':' e::TypeExpr_c ';' { d.ast = varDecls(id.ast, e.ast, location=d.location); }

{--
 - An identifier list
 -}
closed nonterminal Idents with ast<IdList>, location;

concrete productions l::Idents
 | h::Name_c                { l.ast = idListOne(h.ast, location=l.location); }
 | h::Name_c ',' t::Idents  { l.ast = idListCons(h.ast, t.ast, location=l.location); }
 

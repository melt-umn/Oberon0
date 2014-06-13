grammar edu:umn:cs:melt:Oberon0:constructs:procedures:concreteSyntax;

imports edu:umn:cs:melt:Oberon0:core;
imports edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

imports silver:langutil only ast;

{--
 - A (nonempty) list of proc declarations
 -}
closed nonterminal ProcedureDcls with ast<Decl>, location;

-- Must have one procedure, to avoid conflicts with core.
concrete productions d::ProcedureDcls
 | h::ProcedureDcl ';'
   { d.ast = h.ast; }

 | h::ProcedureDcl ';' t::ProcedureDcls  
   { d.ast = seqDecl(h.ast, t.ast, location=d.location); }

{--
 - Individual procedure declaration.
 -}
closed nonterminal ProcedureDcl with ast<Decl>, location;

concrete productions d::ProcedureDcl
 | 'PROCEDURE' id::Name_c p::MaybeParameters ';' d1::Decls_c 'BEGIN' ss::Stmts_c 'END' id2::Name_c 
   { d.ast = procDecl(id.ast, p.ast, d1.ast, ss.ast, id2.ast, location=d.location); }
 -- what is the point of a procedure without a body?

 | 'PROCEDURE' id::Name_c p::MaybeParameters ';' d1::Decls_c 'END' id2::Name_c  
   { d.ast = procDecl(id.ast, p.ast, d1.ast, skip(location=$6.location), id2.ast, location=d.location); }

{--
 - Optional parameter list
 -}
closed nonterminal MaybeParameters with ast<Decl>, location;

concrete productions p::MaybeParameters
 |                        { p.ast = noDecl(location=p.location); }
 | '(' v::Parameters ')'  { p.ast = v.ast; }
 | '(' ')'                { p.ast = noDecl(location=p.location); }

{--
 - Parameter lists for procedure declarations
 -}
closed nonterminal Parameters with ast<Decl>, location;

concrete productions p::Parameters
 | h::Parameter                    { p.ast = h.ast; }
 | h::Parameter ';' t::Parameters  { p.ast = seqDecl(h.ast, t.ast, location=p.location); }

{--
 - Invididual parameters
 -}
closed nonterminal Parameter with ast<Decl>, location;

concrete productions p::Parameter
-- Here we are directly converting this id list to a sequence of the appropriate declarations.
 | ids::Idents ':' t::TypeExpr_c        { local attribute vals :: IdList;
                                          vals = ids.ast;
                                          vals.idVarDeclTypeExpr = t.ast;
                                          vals.idVarDeclProd = paramDeclValue(_, _, location=_);

                                          p.ast = vals.idVarDecls; }

 | 'VAR' ids::Idents ':' t::TypeExpr_c  { local attribute refs :: IdList;
                                          refs = ids.ast;
                                          refs.idVarDeclTypeExpr = t.ast;
                                          refs.idVarDeclProd = paramDeclReference(_, _, location=_);
  
                                          p.ast = refs.idVarDecls; }


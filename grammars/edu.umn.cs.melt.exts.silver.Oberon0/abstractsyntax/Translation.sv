grammar edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax;

-- Silver reflection library
imports silver:reflect;

-- Library implementing object-language to meta-langauge translation
imports silver:metatranslation;

aspect production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{
  -- Here we simply list the names of the antiquote productions that we have introduced,
  -- to be treated specially in the object-language to meta-langauge translation code.
  directAntiquoteProductions <-
    ["edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax:antiquoteStmt",
     "edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax:antiquoteExpr",
     "edu:umn:cs:melt:exts:silver:Oberon0:abstractsyntax:antiquoteName"];
}

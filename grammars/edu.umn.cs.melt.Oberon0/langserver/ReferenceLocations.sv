grammar edu:umn:cs:melt:Oberon0:langserver;

imports silver:langutil;
imports silver:langutil:pp as pp;
import edu:umn:cs:melt:Oberon0:core:abstractSyntax;
import edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;
import edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

monoid attribute varRefLocs::[(Location, Decl)];

attribute varRefLocs occurs on Module, Decl, Stmt, Expr, Exprs, LExpr;
propagate varRefLocs on Module, Decl, Stmt, Expr, Exprs, LExpr;


function findDclOnName
[(Location, Decl)] ::= n::Decorated Name 
{

  return case n.lookupName of
    | just(dcl) -> [(n.location, dcl)]
    | _ -> []
    end;

}

aspect varRefLocs on LExpr using <- of
| idAccess(id) -> findDclOnName(id)
| arrayAccess(_, index) -> index.varRefLocs
| fieldAccess(_, fld) -> findDclOnName(fld)
end;

aspect varRefLocs on Stmt using <- of
| call(n, _) -> findDclOnName(n)
end;

-- Same as in Silver reference locations...
function lookupPos
[a] ::= line::Integer col::Integer items::[(Location, a)]
{
  return map(snd, filter(
    \ item::(Location, a) ->
      item.1.line <= line && item.1.endLine >= line && item.1.column <= col && item.1.endColumn >= col,
    items));
}
-- End repeat functions

function updateLocPath
Location ::= p::String l::Location
{
  -- Don't use l.endLine, l.endColumn, etc. because we want to give lsp just the
  -- "top" of the definition, because VSCode seems to "correct" go-to declaration
  -- if the declaration range overlaps the reference (problem w/ recursive methods)
  -- by inferring that the user meant to "find all references" instead
  return loc(p, l.line, l.column, l.line, l.column, l.index, l.index);
}

function lookupDeclLocation
[Location] ::= fileName::String line::Integer col::Integer decls::[(Location, Decl)]
{
  return map(\dcl::Decl -> updateLocPath(fileName, dcl.location),
    lookupPos(line, col, decls)
  );
}

function findDeclLocation
[Location] ::= fileName::String line::Integer col::Integer m::Maybe<Decorated Module>
{
  return case m of
    | just(mod) -> lookupDeclLocation(fileName, line, col, mod.varRefLocs)
    | _ -> []
  end;
}
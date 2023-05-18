grammar edu:umn:cs:melt:Oberon0:langserver;

imports silver:langutil;
imports silver:langutil:pp as pp;
import edu:umn:cs:melt:Oberon0:core:abstractSyntax;
import edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;
import edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

-- A list of reference locations, maps some reference location in the file to the
-- reference's original declaration
monoid attribute varRefLocs::[(Location, Decl)];

attribute varRefLocs occurs on Module, Decl, Stmt, Expr, Exprs, LExpr;
propagate varRefLocs on Module, Decl, Stmt, Expr, Exprs, LExpr;

-- Given a Decorated Name, extract the location & declaration from that name if it exists 
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
-- TODO: Does it make sense to import this function from the Silver reference locations?
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
  -- Hack
  -- Don't use l.endLine, l.endColumn, etc. because we want to give lsp just the
  -- "top" of the definition, because VSCode seems to "correct" go-to declaration
  -- if the declaration range overlaps the reference (problem w/ recursive methods)
  -- by inferring that the user meant to "find all references" instead
  -- Ideally we want declaration locations in an environment to indicate the name
  -- that's being declared rather than the full declaration, but this hack accomplishes
  -- a similar visual indication for the user w/o changing the Oberon0 environment
  return loc(p, l.line, l.column, l.line, l.column, l.index, l.index);
}

-- Given a location in a file name & a list of declarations, lookup that declaration by the location
-- of the reference
-- Return a list of source locations for that declaration
function lookupDeclLocation
[Location] ::= fileName::String line::Integer col::Integer decls::[(Location, Decl)]
{
  return map(\dcl::Decl -> updateLocPath(fileName, dcl.location),
    lookupPos(line, col, decls)
  );
}

-- Given a location in a file and the decorated module for that file, extract all
-- the reference locations in the file and lookup a declaration by the given reference location 
function findDeclLocation
[Location] ::= fileName::String line::Integer col::Integer m::Maybe<Decorated Module>
{
  return case m of
    | just(mod) -> lookupDeclLocation(fileName, line, col, mod.varRefLocs)
    | _ -> []
  end;
}
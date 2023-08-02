grammar edu:umn:cs:melt:exts:Oberon0:tables:abstractSyntax;

imports edu:umn:cs:melt:Oberon0:core:abstractSyntax as abs;
imports edu:umn:cs:melt:Oberon0:core:typeChecking;
imports edu:umn:cs:melt:Oberon0:tasks:lift:core;
imports edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

imports silver:langutil;
imports silver:langutil:pp;

-- For LSP
imports silver:langutil:lsp;
imports edu:umn:cs:melt:Oberon0:langserver;

abstract production table
top::abs:Expr ::= trows::TableRows
{
  top.pp = ppConcat( [text("table {"), line(), trows.pp, text(" }")] );

  top.type = booleanType();

  top.varRefLocs := trows.varRefLocs;
  
  propagate abs:env, errors;

  --forwards to 

}

-- Table Rows --
----------------
nonterminal TableRows with pp, errors, abs:env, location,
   rlen, varRefLocs;
propagate abs:env on TableRows;
synthesized attribute rlen :: Integer;

abstract production tableRowSnoc
top::TableRows ::= trowstail::TableRows  trow::TableRow
{
  top.pp = ppConcat([trowstail.pp, line(), trow.pp]);

  top.errors := trowstail.errors ++ trow.errors;
  top.errors <-
    if trow.rlen == trowstail.rlen then [] else
      [err(trowstail.location,
        "The number of T,F,* entries in table row must be the same " ++
        "as the preceding rows")];

  top.rlen = trow.rlen;

  top.varRefLocs := trowstail.varRefLocs ++ trow.varRefLocs;
}

abstract production tableRowOne
top::TableRows ::= trow::TableRow
{
  top.pp = trow.pp;
  top.errors := trow.errors;
  top.rlen = trow.rlen;

  top.varRefLocs := trow.varRefLocs;

}

-- Table Row --
---------------
nonterminal TableRow with pp, errors, abs:env, location,
  rlen, varRefLocs;
propagate abs:env on TableRow;

abstract production tableRow
top::TableRow ::= e::abs:Expr tvl::TruthFlagList
{
  top.pp = ppConcat([e.pp, text(" : "), tvl.pp]);
  top.errors := e.errors;
  top.errors <- checkErrors (e.type, booleanType(), "Condition expression", e.location);
  
  top.rlen = tvl.rlen;

  top.varRefLocs := e.varRefLocs;
}

-- Truth Value List --
----------------------
nonterminal TruthFlagList with pp, rlen, ftExprs;
synthesized attribute ftExprs :: [String];

abstract production tvlistCons
top::TruthFlagList ::= tv::TruthFlag tvltail::TruthFlagList
{
  top.pp = ppConcat([tv.pp, text(" "), tvltail.pp]);
  top.rlen = 1 + tvltail.rlen;
}

abstract production tvlistOne
top::TruthFlagList ::= tv::TruthFlag
{
  top.pp = tv.pp;
  top.rlen = 1;
}

-- Truth Values
---------------
nonterminal TruthFlag with pp, ftExpr;
synthesized attribute ftExpr :: String;

abstract production tvTrue
top::TruthFlag ::=
{
  top.pp = text("T");

  top.ftExpr = "TRUE";

}

abstract production tvFalse
top::TruthFlag ::=
{
  top.pp = text("F");
  -- top.ftExpr = 
}

abstract production tvStar
top::TruthFlag ::=
{
  top.pp = text("*");
  top.ftExpr = "TRUE"; 
}

-- Our AST construction helper functions

function logicalNegate
abs:Expr ::= ne::abs:Expr
{
  return abs:notOp(ne, location=ne.location);
}

function logicalOr
abs:Expr ::= e1::abs:Expr e2::abs:Expr
{
  return abs:orOp(e1, e2, location=e1.location);
}
function logicalAnd
abs:Expr ::= e1::abs:Expr e2::abs:Expr
{
  return abs:andOp(e1, e2, location=e1.location);
}

-- table helper functions
-------------------------
function disjunction
abs:Expr ::= es::[abs:Expr]
{
  return if length(es) == 1 then head(es)
         else logicalOr(head(es), disjunction(tail(es)));
}
function mapConjunction
[abs:Expr] ::= ess::[[abs:Expr]]
{
  return if null(ess) then [] 
         else cons(conjunction(head(ess)),
                     mapConjunction(tail(ess)));
}
function conjunction
abs:Expr ::= es::[abs:Expr]
{
  return if length(es) == 1 then head(es)
         else logicalAnd(head(es), conjunction(tail(es)));
}
function transpose
[[a]] ::= m::[[a]]
{
  return
    case m of
    | [] :: _ -> []
    | _       -> map(head,m) :: transpose(map(tail,m))
    end;
}
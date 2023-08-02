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

  forwards to disjunction(mapConjunction(transpose(trows.ftExprss)));

}

-- Table Rows --
----------------
nonterminal TableRows with pp, errors, abs:env, location,
   ftExprss, rlen, varRefLocs;
propagate abs:env on TableRows;

synthesized attribute ftExprss :: [[abs:Expr]];
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
  top.ftExprss = trowstail.ftExprss ++ [trow.ftExprs];

  top.varRefLocs := trowstail.varRefLocs ++ trow.varRefLocs;
  
}

abstract production tableRowOne
top::TableRows ::= trow::TableRow
{
  top.pp = trow.pp;
  top.errors := trow.errors;

  top.rlen = trow.rlen;
  top.ftExprss = [trow.ftExprs];

  top.varRefLocs := trow.varRefLocs;
  
}

-- Table Row --
---------------
nonterminal TableRow with pp, errors, abs:env, location,
  ftExprs, rlen, varRefLocs;
propagate abs:env on TableRow;

abstract production tableRow
top::TableRow ::= e::abs:Expr tvl::TruthFlagList
{
  top.pp = ppConcat([e.pp, text(" : "), tvl.pp]);
  top.errors := e.errors;
  top.errors <- checkErrors (e.type, booleanType(), "Condition expression", e.location);
  
  top.rlen = tvl.rlen;
  top.ftExprs = tvl.ftExprs;

  top.varRefLocs := e.varRefLocs;

  tvl.rowExpr = e;
  
}

-- Truth Value List --
----------------------
nonterminal TruthFlagList with pp, rlen, ftExprs, rowExpr;
inherited attribute rowExpr :: abs:Expr;
synthesized attribute ftExprs :: [abs:Expr];

abstract production tvlistCons
top::TruthFlagList ::= tv::TruthFlag tvltail::TruthFlagList
{
  top.pp = ppConcat([tv.pp, text(" "), tvltail.pp]);
  top.rlen = 1 + tvltail.rlen;

  top.ftExprs = tv.ftExpr :: tvltail.ftExprs;
  tv.rowExpr = top.rowExpr;
  tvltail.rowExpr = top.rowExpr;
}

abstract production tvlistOne
top::TruthFlagList ::= tv::TruthFlag
{
  top.pp = tv.pp;
  top.rlen = 1;

  top.ftExprs = [tv.ftExpr];
  tv.rowExpr = top.rowExpr;

}

-- Truth Values
---------------
nonterminal TruthFlag with pp, location, ftExpr, rowExpr;
synthesized attribute ftExpr :: abs:Expr;

abstract production tvTrue
top::TruthFlag ::=
{
  top.pp = text("T");

  top.ftExpr = top.rowExpr;
}

abstract production tvFalse
top::TruthFlag ::=
{
  top.pp = text("F");
  top.ftExpr = logicalNegate(top.rowExpr);

}

abstract production tvStar
top::TruthFlag ::=
{
  top.pp = text("*");
  -- TODO: Thinking I'll need to make a var decl assigned to TRUE so that I can then use it
  -- as *? Not 100% sure how to access a constant "true" value. Still thinking on this but below is
  -- a hack for now.
  top.ftExpr = abs:eqOp(abs:number("1",location=top.location), abs:number("1",location=top.location), location=top.location);
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
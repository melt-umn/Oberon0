grammar edu:umn:cs:melt:exts:Oberon0:tables:abstractSyntax;

imports edu:umn:cs:melt:Oberon0:core:abstractSyntax as abs;

imports silver:langutil;
imports silver:langutil:pp;

abstract production table
top::abs:Expr ::= trows::TableRows
{
  top.pp = ppConcat( [text("table ("), line(), trows.pp, text(" )")] );
  propagate abs:env;

}

-- Table Rows --
----------------
nonterminal TableRows with pp, errors, abs:env, location,
  ftExprss, rlen, preDecls;
-- TODO: The ableC TableRows also have an attribute from ableC "controlStmtContext"
-- I'm unsure yet if this is needed or how to represent this in Oberon0

-- TODO: How we are using Stmt + Expr
synthesized attribute preDecls :: [abs:Stmt];
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
  top.preDecls = trowstail.preDecls ++ trow.preDecls;

}

abstract production tableRowOne
top::TableRows ::= trow::TableRow
{
  top.pp = trow.pp;
  top.errors := trow.errors;
  top.rlen = trow.rlen;
  top.ftExprss = [trow.ftExprs];
  top.preDecls = trow.preDecls;
}

-- Table Row --
---------------
nonterminal TableRow with pp, errors, abs:env, location,
  ftExprs, rlen, preDecls;

synthesized attribute ftExprs :: [abs:Expr];

abstract production tableRow
top::TableRow ::= e::abs:Expr tvl::TruthFlagList
{

  top.pp = ppConcat([e.pp, text(" : "), tvl.pp]);
  top.errors := e.errors;
  top.rlen = tvl.rlen;
  top.ftExprs = tvl.ftExprs;

  --top.errors <- checkErrors (e.type, booleanType(), "Condition expression", e.location);


  -- TODO

}

-- Truth Value List --
----------------------
nonterminal TruthFlagList with pp, rowExpr, ftExprs, rlen;

inherited attribute rowExpr :: abs:Expr;
-- the expression in the table row.  It is passed down to the TF*
-- values to be used in the translation to the host language.

abstract production tvlistCons
top::TruthFlagList ::= tv::TruthFlag tvltail::TruthFlagList
{
  --TODO
}

abstract production tvlistOne
top::TruthFlagList ::= tv::TruthFlag
{
  -- TODO
}

-- Truth Values
---------------
nonterminal TruthFlag with pp, rowExpr, ftExpr;
synthesized attribute ftExpr :: abs:Expr;

abstract production tvTrue
top::TruthFlag ::=
{
  --TODO
  --top.pp = text("T");
  --top.ftExpr = top.rowExpr;
}

abstract production tvFalse
top::TruthFlag ::=
{
  --TODO
  --top.pp = text("F");
}

abstract production tvStar
top::TruthFlag ::=
{
  -- TODO
}

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

  top.lifted = table(trows.lifted, location=trows.location);
  top.cTrans = "table {" ++ trows.cTrans ++ "}";

  top.varRefLocs := trows.varRefLocs;
  
  propagate abs:env, errors;

}

-- Table Rows --
----------------
nonterminal TableRows with pp, errors, abs:env, location,
   rlen, cTrans, varRefLocs;
propagate abs:env on TableRows;
synthesized attribute rlen :: Integer;

attribute lifted<TableRows> occurs on TableRows;

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

  top.lifted = tableRowSnoc(trowstail.lifted, trow.lifted, location=top.location);
  top.cTrans = trowstail.cTrans ++ "\n" ++ trow.cTrans;

  top.varRefLocs := trowstail.varRefLocs ++ trow.varRefLocs;
}

abstract production tableRowOne
top::TableRows ::= trow::TableRow
{
  top.pp = trow.pp;
  top.errors := trow.errors;
  top.rlen = trow.rlen;

  top.lifted = tableRowOne(trow.lifted, location=top.location);

  top.cTrans = trow.cTrans;

  top.varRefLocs := trow.varRefLocs;

}

-- Table Row --
---------------
nonterminal TableRow with pp, errors, abs:env, location,
  rlen, cTrans, varRefLocs;
propagate abs:env on TableRow;

attribute lifted<TableRow> occurs on TableRow;

abstract production tableRow
top::TableRow ::= e::abs:Expr tvl::TruthFlagList
{
  top.pp = ppConcat([e.pp, text(" : "), tvl.pp]);
  top.errors := e.errors;
  top.errors <- checkErrors (e.type, booleanType(), "Condition expression", e.location);
  
  top.rlen = tvl.rlen;

  top.lifted = tableRow(e.lifted, tvl.lifted, location=top.location);
  top.cTrans = e.cTrans ++ " : " ++ tvl.cTrans;

  top.varRefLocs := e.varRefLocs;
}

-- Truth Value List --
----------------------
nonterminal TruthFlagList with pp, rlen, cTrans;
attribute lifted<TruthFlagList> occurs on TruthFlagList;

abstract production tvlistCons
top::TruthFlagList ::= tv::TruthFlag tvltail::TruthFlagList
{
  top.pp = ppConcat([tv.pp, text(" "), tvltail.pp]);
  top.rlen = 1 + tvltail.rlen;
  top.lifted = tvlistCons(tv.lifted, tvltail.lifted);

  top.cTrans = tv.cTrans ++ " " ++ tvltail.cTrans;
}

abstract production tvlistOne
top::TruthFlagList ::= tv::TruthFlag
{
  top.pp = tv.pp;
  top.rlen = 1;
  top.lifted = tvlistOne(tv.lifted);

  top.cTrans = tv.cTrans;
}

-- Truth Values
---------------
nonterminal TruthFlag with pp, cTrans;
attribute lifted<TruthFlag> occurs on TruthFlag;

abstract production tvTrue
top::TruthFlag ::=
{
  top.pp = text("T");
  top.lifted = top;

  top.cTrans = "T";
}

abstract production tvFalse
top::TruthFlag ::=
{
  top.pp = text("F");
  top.lifted = top;

  top.cTrans = "F";
}

abstract production tvStar
top::TruthFlag ::=
{
  top.pp = text("*");
  top.lifted = top;

  top.cTrans = "*";
}

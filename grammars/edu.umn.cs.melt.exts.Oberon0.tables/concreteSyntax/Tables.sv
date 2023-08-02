grammar edu:umn:cs:melt:exts:Oberon0:tables:concreteSyntax;

imports edu:umn:cs:melt:Oberon0:core:concreteSyntax as cnc;

imports edu:umn:cs:melt:exts:Oberon0:tables:abstractSyntax;

imports silver:langutil;

-- Terminals
marking terminal Table_t 'TABLE' lexer classes { cnc:KEYWORD };

terminal LCurly_t '{'; -- action { context = head(context) :: context; };
terminal RCurly_t '}'; -- action { context = tail(context); };

terminal NewLine_t /[\r]?\n/;
terminal TrueTV_t   'T';
terminal FalseTV_t  'F';
terminal StarTV_t   '*';

ignore terminal Spaces_t /[\t ]+/;

disambiguate NewLine_t, cnc:WhiteSpace
{
  pluck NewLine_t;
}

disambiguate Spaces_t, cnc:WhiteSpace
{
  pluck Spaces_t;
}

-- Nonterminals
nonterminal TableRows_c with ast<TableRows>, location;
nonterminal TableRow_c  with ast<TableRow>, location;
nonterminal TruthValueList_c  with ast<TruthFlagList>, location;
nonterminal TruthValue_c with ast<TruthFlag>, location;

-- Productions
concrete production table_c
top::cnc:Expr_c ::= 'TABLE' '{' trows::TableRows_c '}'
layout { Spaces_t }
{
  top.ast = table(trows.ast, location=top.location);
}

concrete production tableRowSnoc_c
top::TableRows_c ::= trowstail::TableRows_c  n::NewLine_t  trow::TableRow_c
layout { Spaces_t }
{
  top.ast = tableRowSnoc(trowstail.ast, trow.ast, location=top.location);
}

concrete production tableRowOne_c
top::TableRows_c ::= trow::TableRow_c
{
  top.ast = tableRowOne(trow.ast, location=top.location);
}

concrete production tableRow_c
top::TableRow_c ::= e::cnc:Expr_c ':' tvs::TruthValueList_c
{
  top.ast = tableRow(e.ast, tvs.ast, location=top.location);
}

concrete production tvlistCons_c
top::TruthValueList_c ::= tv::TruthValue_c  tvltail::TruthValueList_c
{
  top.ast = tvlistCons(tv.ast, tvltail.ast);
}

concrete production tvlistOne_c
top::TruthValueList_c ::= tv::TruthValue_c
{
  top.ast = tvlistOne(tv.ast);
}

concrete production tvTrue_c
top::TruthValue_c ::= truetv::TrueTV_t
{
  top.ast = tvTrue(location=top.location);
}

concrete production tvFalse_c
top::TruthValue_c ::= falsetv::FalseTV_t
{
  top.ast = tvFalse(location=top.location);
}

concrete production tvStar_c
top::TruthValue_c ::= startv::StarTV_t
{
  top.ast = tvStar(location=top.location);
}
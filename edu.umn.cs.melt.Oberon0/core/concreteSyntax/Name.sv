grammar edu:umn:cs:melt:Oberon0:core:concreteSyntax;

closed nonterminal Name_c with ast<Name>, location;

concrete production name_c
n::Name_c ::= id::Id_t
{
  n.ast = name(id.lexeme, location=id.location);
}

closed nonterminal TypeName_c with ast<TypeName>, location;

concrete production typeName_c
n::TypeName_c ::= id::Id_t
{
  n.ast = typeName(id.lexeme, location=id.location);
}


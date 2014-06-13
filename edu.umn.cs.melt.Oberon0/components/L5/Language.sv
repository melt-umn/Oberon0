grammar edu:umn:cs:melt:Oberon0:components:L5;

exports edu:umn:cs:melt:Oberon0:components:L4; -- reuse L4's parser

aspect production idAccess
e::LExpr ::= id::Name
{
  permitOnlyTopLevelAndLocalAccess <- false;
}


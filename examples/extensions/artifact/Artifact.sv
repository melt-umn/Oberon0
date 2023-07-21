grammar artifact;

import edu:umn:cs:melt:Oberon0:components:T3;
import edu:umn:cs:melt:Oberon0:components:T5;


import edu:umn:cs:melt:Oberon0:core;
import edu:umn:cs:melt:Oberon0:constructs:controlFlow;
import edu:umn:cs:melt:Oberon0:constructs:procedures;
import edu:umn:cs:melt:Oberon0:constructs:dataStructures;

-- import edu:umn:cs:melt:Oberon0:langserver;

import edu:umn:cs:melt:Oberon0:core:driver;

parser parse::Module_c {
  edu:umn:cs:melt:Oberon0:core;
  edu:umn:cs:melt:Oberon0:constructs:controlFlow;
  edu:umn:cs:melt:Oberon0:constructs:procedures;
  edu:umn:cs:melt:Oberon0:constructs:dataStructures;
  edu:umn:cs:melt:exts:Oberon0:tables;
}


aspect production idAccess
e::LExpr ::= id::Name
{
  permitOnlyTopLevelAndLocalAccess <- false;
}

function main
IOVal<Integer> ::= args::[String] mainIO::IOToken
{
  return driver(args, parse, mainIO);
}
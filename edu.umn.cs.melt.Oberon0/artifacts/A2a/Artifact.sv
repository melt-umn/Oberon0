grammar edu:umn:cs:melt:Oberon0:artifacts:A2a;

import edu:umn:cs:melt:Oberon0:components:L3 as L3;

import edu:umn:cs:melt:Oberon0:core:driver;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
  return driver(args, L3:parse, mainIO);
}


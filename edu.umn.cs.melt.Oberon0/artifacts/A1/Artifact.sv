grammar edu:umn:cs:melt:Oberon0:artifacts:A1;

import edu:umn:cs:melt:Oberon0:components:L2 as L2;

import edu:umn:cs:melt:Oberon0:core:driver;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
  return driver(args, L2:parse, mainIO);
}


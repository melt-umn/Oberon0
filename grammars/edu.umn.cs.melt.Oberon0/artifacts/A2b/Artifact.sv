grammar edu:umn:cs:melt:Oberon0:artifacts:A2b;

import edu:umn:cs:melt:Oberon0:components:L2 as L2;
import edu:umn:cs:melt:Oberon0:components:T3;

import edu:umn:cs:melt:Oberon0:core:driver;

function main
IOVal<Integer> ::= args::[String] mainIO::IOToken
{
  return driver(args, L2:parse, mainIO);
}


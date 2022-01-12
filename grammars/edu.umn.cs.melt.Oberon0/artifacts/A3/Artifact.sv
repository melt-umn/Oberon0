grammar edu:umn:cs:melt:Oberon0:artifacts:A3;

import edu:umn:cs:melt:Oberon0:components:L3 as L3;
import edu:umn:cs:melt:Oberon0:components:T3;

import edu:umn:cs:melt:Oberon0:core:driver;

function main
IOVal<Integer> ::= args::[String] mainIO::IOToken
{
  return driver(args, L3:parse, mainIO);
}


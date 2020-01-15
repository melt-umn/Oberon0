grammar edu:umn:cs:melt:Oberon0:artifacts:A5;

import edu:umn:cs:melt:Oberon0:components:L5 as L5;
import edu:umn:cs:melt:Oberon0:components:T3;
import edu:umn:cs:melt:Oberon0:components:T5;

import edu:umn:cs:melt:Oberon0:core:driver;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
  return driver(args, L5:parse, mainIO);
}


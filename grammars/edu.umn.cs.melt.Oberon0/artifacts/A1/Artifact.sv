grammar edu:umn:cs:melt:Oberon0:artifacts:A1;

import edu:umn:cs:melt:Oberon0:components:L2 as L2;

import edu:umn:cs:melt:Oberon0:core:driver;

fun main IOVal<Integer> ::= args::[String] mainIO::IOToken = driver(args, L2:parse, mainIO);


grammar edu:umn:cs:melt:Oberon0:artifacts:A4;

imports edu:umn:cs:melt:Oberon0:components:L4 as L4;
imports edu:umn:cs:melt:Oberon0:components:T3;
imports edu:umn:cs:melt:Oberon0:components:T5;
imports edu:umn:cs:melt:Oberon0:core:driver only driver;

function main IOVal<Integer> ::= args::[String] mainIO::IOToken
{ return driver(args, L4:parse, mainIO); }

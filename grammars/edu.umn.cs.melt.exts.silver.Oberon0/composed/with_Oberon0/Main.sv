grammar edu:umn:cs:melt:exts:silver:Oberon0:composed:with_Oberon0;

import silver:compiler:host;

parser svParse::Root {
  silver:compiler:host;
  
  edu:umn:cs:melt:exts:silver:Oberon0;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, ioin);
}

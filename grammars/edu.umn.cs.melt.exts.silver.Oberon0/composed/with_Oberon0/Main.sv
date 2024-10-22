grammar edu:umn:cs:melt:exts:silver:Oberon0:composed:with_Oberon0;

import silver:compiler:host;

parser svParse::Root {
  silver:compiler:host;
  
  edu:umn:cs:melt:exts:silver:Oberon0;
}

fun main IO<Integer> ::= args::[String] = cmdLineRun(args, svParse);

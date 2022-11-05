grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

imports silver:langutil;
imports silver:langutil:pp as pp;

option edu:umn:cs:melt:Oberon0:constructs:dataStructures;
option edu:umn:cs:melt:Oberon0:constructs:procedures;

{--
 - Environments information.
 - See Env.sv for an explanation of why this is Decorated.
 -}
inherited attribute env :: Decorated Env;  --T2



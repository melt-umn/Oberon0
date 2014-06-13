grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

imports edu:umn:cs:melt:Oberon0:core;
imports edu:umn:cs:melt:Oberon0:tasks:lift:core;

{-
 - Most of the "task for construct" grammars are trigger-built by the task.
 - For example, construct:dataStructures builds the :typechecking grammar
 - below it if type checking task is included.  We do code generation
 - differently, just to show that it can be done either way.
 -
 - Notice that we include nothing for the 'controlFlow' construct.
 - That's because it is a "proper language extension" in our sense,
 - where it forwards to its 'semantic equivalent' in the host language.
 -}
exports edu:umn:cs:melt:Oberon0:tasks:codegenC:procedures
  with edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

exports edu:umn:cs:melt:Oberon0:tasks:codegenC:dataStructures
  with edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

{--
 - The C translation of the Oberon0 code, simply built up as a string.
 -
 - It's specific meaning might vary with nonterminal. For example, the
 - 'cTrans' of a type should be a C type, while the 'cTrans' of an expression
 - should be a C expression, and so on with statement, etc.
 -
 - The 'cTrans' of Module will be a whole C file.
 -}
synthesized attribute cTrans :: String;


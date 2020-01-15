grammar edu:umn:cs:melt:Oberon0:tasks:lift:core;

imports edu:umn:cs:melt:Oberon0:core;

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
exports edu:umn:cs:melt:Oberon0:tasks:lift:procedures
  with edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

exports edu:umn:cs:melt:Oberon0:tasks:lift:dataStructures
  with edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;

{--
 - In order to do unique naming of all variables, we thread through
 - a set of already used names.  For simplicity, we just use a list here,
 - a more sophisticated compiler would probably use a different data structure,
 - such as silver:util:treemap.
 -
 - @see universalNamesIn
 -}
synthesized attribute universalNamesOut :: [String];
{--
 - This pair of attributes is used to thread the current `state' of used
 - names through the tree explicitly.  This one is given to a subtree,
 - and the other comes out as a result.
 -
 - @see universalNamesOut
 -}
inherited attribute universalNamesIn :: [String];

{--
 - The transformed tree of Oberon0 code, after lambda-lifting and unique renaming
 - has been performed.
 -
 - The type will match the nonterminal it occurs on.
 -}
synthesized attribute lifted<a> :: a;

{--
 - The set of declarations to be lifted all the way up to the top level (i.e.
 - Module instead of a Procedure).
 -}
synthesized attribute liftedDecls :: [Decl];

{--
 - Used to support lambda-lifting.  The set of 'free variables' in whatever
 - tree it is accessed upon.
 -
 - Only consider VAR and PROCEDURE references. CONST and TYPE can all be
 - lifted to top-level anyway.
 -}
synthesized attribute freevars :: [Decorated Decl];



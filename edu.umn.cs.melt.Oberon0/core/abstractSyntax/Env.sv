grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

{-
 - import a red-black tree data structure.
 -}
import silver:util:treemap;

{-
 - This file is a demonstration of complex extensible environments in Silver.
 - For Oberon0, it is overcomplicated, and this entire file could be
 - erased, and the 'env' attribute simply changed to be a
 - TreeMap<String  (Decorated Decl)> directly.
 - 
 - However, this file is a good demonstration of how to set up an environment
 - that can scale up to just about any language.

 - Ted: can we say something about what scaling up means?
 - e.g. adding new name spaces, new types, new ???
 -}

{-
  A type representing an environment. In this case, with two namespaces:
  that of values and types.
 
  This type's purpose is just to be a container for its inherited attributes,
  thus, it should always be passed around decorated, otherwise it is meaningless.
  Ted: "meaningless" or just "inefficient" - which is what is suggested below.
 
  No operations other than 'emptyEnv' 'newScope' and 'addDefs' can operate on
  Env. The point is that any extensions which wish to add to the environment
  can aspect this fixed set of operations to introduce any new namespace they wish.
 
  The reason for passing this around decorated is to ensure the environment is
  re-used, and never "reconstructed."
 -}
nonterminal Env with types, values;

inherited attribute types :: [ TreeMap<String Decorated Decl> ];
inherited attribute values :: [ TreeMap<String Decorated Decl> ];

{--
 - A dumb container for the unrestricted set of inherited attributes that
 - occurs on 'Env'. No other constructors exist.
 -}
abstract production envRecord
e::Env ::=
{
}

{--
 - An empty environment.
 -}
function emptyEnv
Decorated Env ::=
{
  -- By constructing the decorated value using a production attribute
  -- extension are able to add equations for new inherited attributes
  -- using 'aspect function'.
  production attribute e::Env;
  e = envRecord();
  e.types = [treeNew(compareString)];
  e.values = [treeNew(compareString)];
  return e;
}

{--
 - Put (empty) new scopes at the beginning of every namespace.
 -}
function newScope
Decorated Env ::= e1::Decorated Env
{
  production attribute e::Env;
  e = envRecord();
  e.types = [treeNew(compareString)] ++ e1.types;
  e.values = [treeNew(compareString)] ++ e1.values;
  return e;
}

{--
 - Take a set of definitions, and introduce them to the environment
 - in the current scope.
 -}
function addDefs
Decorated Env ::= d::Defs  e1::Decorated Env
{
  production attribute e::Env;
  e = envRecord();
  e.types = treeConvert(d.typeDefs,head(e1.types)) :: tail(e1.types);
  e.values = treeConvert(d.valueDefs,head(e1.values)) :: tail(e1.values);
  return e;
}

--------------------------------------------------------------------------------

{--
 - A type representing a set of definitions, to add to the environment.
 -
 - Here, we have two fixed constructors: 'noDefs' and 'appendDefs'.
 - HOWEVER, we can now introduce arbitrary sets of definition-introducing
 - productions by forwarding down to these, but with modifications.
 -
 - This type is a nice extensible record, but every time it is decorated
 - it reconstructs all of its values from scratch. Since it must be undecorated
 - to allow forwarding to operate, we have a companion type 'Env' to actually
 - represent the environment, guaranteeing for us that each 'Defs' is only
 - ever decorated once: when its contents are added to 'Env'.
 -}
nonterminal Defs with typeDefs, valueDefs;

synthesized attribute typeDefs :: [ Pair<String  Decorated Decl> ];
synthesized attribute valueDefs :: [ Pair<String  Decorated Decl> ];

{--
 - Add nothing to the environment.
 -}
abstract production noDefs
e::Defs ::=
{
  e.typeDefs = [];
  e.valueDefs = [];
}

{--
 - Join two sets of definitions to add to the environment.
 -}
abstract production appendDefs
e::Defs ::= d1::Defs  d2::Defs
{
  e.typeDefs = d1.typeDefs ++ d2.typeDefs;
  e.valueDefs = d1.valueDefs ++ d2.valueDefs;
}

--------------------------------------------------------------------------------

{-
 - There is no special status for the following constructors:
 - an extension is free to introduce its own following this pattern, as well.
 -}

{--
 - A defs representing adding one value to the environment.
 -}
abstract production valueDef
e::Defs ::= s::String  d::Decorated Decl
{
  e.valueDefs = [pair(s, d)];
  forwards to noDefs();
}

{--
 - A defs representing adding one type to the environment.
 -}
abstract production typeDef
e::Defs ::= s::String  d::Decorated Decl
{
  e.typeDefs = [pair(s, d)];
  forwards to noDefs();
}

--------------------------------------------------------------------------------

{-
 - Now we have the lookup operations on the environment.
 -}

function lookupDecl
Maybe<Decorated Decl> ::= s::String e::Decorated Env
{
  return lookupValue(s,e) ;
}




{--
 - A helper that adapts a list to a Maybe, discarding any extra elements in the list.
 -}
function adapt
Maybe<a> ::= l::[a]
{
  return if null(l) then nothing() else just(head(l));
}

{--
 - A helper that looks a name up in each scope.
 -
 - Thanks to laziness, it's not inefficient to use this, as we'll only
 - actually do the lookup as far as gets demanded in the scope list.
 -}
function lookupInScopes
[Maybe<a>] ::= s::String ss::[TreeMap<String a>]
{
  return map(adapt, map(treeLookup(s,_), ss));
}

{--
 - Looks up a type in the nearest scope containing it.
 -}
function lookupType
Maybe<Decorated Decl> ::= s::String e::Decorated Env
{
  return foldr(orElse, nothing(), lookupInScopes(s, e.types));
}

{--
 - Looks up a value in the nearest scope containing it.
 -}
function lookupValue
Maybe<Decorated Decl> ::= s::String e::Decorated Env
{
  return foldr(orElse, nothing(), lookupInScopes(s, e.values));
}

{--
 - Looks up a type in the most-local scope ONLY.
 -}
function lookupTypeInScope
Maybe<Decorated Decl> ::= s::String e::Decorated Env
{
  return head(lookupInScopes(s,e.types));
}

{--
 - Looks up a value in the most-local scope ONLY.
 -}
function lookupValueInScope
Maybe<Decorated Decl> ::= s::String e::Decorated Env
{
  return head(lookupInScopes(s,e.values));
}


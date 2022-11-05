grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Name with location, pp,
  env, errors, lookupName, name; --T2

propagate env on Name;

{--
 - Focus most of the name-lookup code on names themselves.
 - This attribute is the result of looking up the name in the environment.
 -   nothing() represents the name lookup failing.
 -}
synthesized attribute lookupName :: Maybe<Decorated Decl>; --T2
{--
 - The 'pp' attribute has another purpose, really, so we give names
 - a special attribute specifically for obtaining the name.
 -}
synthesized attribute name :: String; --T2

abstract production name
n::Name ::= s::String
{
  n.pp = pp:text(s);
  --T2-start
  n.name = s;
  
  n.lookupName = lookupValue(s, n.env);
  
  n.errors := case n.lookupName of
              | nothing() -> [err(n.location, "Undeclared value " ++ s)]
              | just(_) -> []
              end;
  --T2-end
}

nonterminal TypeName with location, pp,
  env, errors, lookupName, name;  --T2

propagate env on TypeName;

abstract production typeName
n::TypeName ::= s::String
{
  n.pp = pp:text(s);
  --T2-start
  n.name = s;
  
  n.lookupName = lookupType(s, n.env);
  
  n.errors := case n.lookupName of
              | nothing() -> [err(n.location, "Undeclared type " ++ s)]
              | just(_) -> []
              end;
  --T2-end
}


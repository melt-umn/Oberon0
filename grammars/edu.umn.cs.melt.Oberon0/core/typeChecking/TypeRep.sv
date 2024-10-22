grammar edu:umn:cs:melt:Oberon0:core:typeChecking;

imports edu:umn:cs:melt:Oberon0:core;

imports silver:langutil;
imports silver:langutil:pp as pp;

option edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking;
option edu:umn:cs:melt:Oberon0:constructs:procedures:typeChecking;

{--
 - The TypeRep of a TypeExpr, Expr, etc.
 -}
synthesized attribute type :: TypeRep;

{--
 - A TypeExpr represents the abstract syntax of a type that might appear in
 - the text of a program.  TypeRep represents the actual, resulting type.
 -
 - The distinction is one of lookup. A TypeExpr can be invalid. A TypeRep
 - is either errorType or perfectly valid, and no further environment lookups
 - are needed for it.
 -}
nonterminal TypeRep with pp;

{--
 - nominalType here actually ONLY exists to print more user friendly error
 - messages. It otherwise behaves like the TypeRep it references.
 -}
abstract production nominalType
t::TypeRep ::= n::String real::TypeRep
{
  t.pp = pp:text(n);
  forwards to @real;
}

abstract production integerType
t::TypeRep ::=
{
  t.pp = pp:text("INTEGER");
}

abstract production booleanType
t::TypeRep ::=
{
  t.pp = pp:text("BOOL");
}

abstract production errorType
t::TypeRep ::=
{
  t.pp = pp:text("unknown");
}


{--
 - Check for type equality.
 - 
 - @return  true if no type error should be raised, false otherwise.
 -}
function check
Boolean ::= t1::TypeRep t2::TypeRep
{
  -- Extensions can change false to true if they wish, thanks to the collection
  -- operator ||.
  production attribute valid :: Boolean with ||;
  valid := case t1, t2 of
           -- Equal types
           | integerType(),   integerType() -> true
           | booleanType(),      booleanType() -> true
           -- Accept any error type, as the error is already reported.
           | _,               errorType() -> true
           | errorType(),     _ -> true
           -- Reject anything else.
           | _,               _ -> false
           end;
  
  return valid;
}

{--
 - Constructs an error message for a type error, if needed.
 -
 - @param actual  The actual type
 - @param expected  The expected type
 - @param object  The name of the thing whose type is being checked
 - @param l  The location of said thing.
 - @return  An error message regarding the type error, or the empty list.
 -}
function checkErrors
[Message] ::= actual::TypeRep  expected::TypeRep  object::String  l::Location
{
  return if check(^actual, ^expected) then []
         else [err(l, object ++ " was expected to have type " ++ pp:show(100, expected.pp) ++
                 ", but instead has type " ++ pp:show(100, actual.pp))];
}


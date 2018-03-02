grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking;

imports edu:umn:cs:melt:Oberon0:core;
imports edu:umn:cs:melt:Oberon0:constructs:dataStructures:abstractSyntax;
imports edu:umn:cs:melt:Oberon0:core:typeChecking;

imports silver:langutil;
imports silver:langutil:pp as pp;

abstract production arrayType
t::TypeRep ::= e::Decorated Expr ty::TypeRep uniqueid::Integer
{
  t.pp = pp:ppConcat([pp:text("ARRAY "), e.pp, pp:text(" OF "), ty.pp]);
}

abstract production recordType
t::TypeRep ::= f::Decorated Decl uniqueid::Integer
{
  t.pp = pp:ppConcat([pp:text("RECORD "), pp:ppImplode(pp:text("; "), map((.pp), f.individualDcls)), pp:text(" END")]);
}

aspect function check
Boolean ::= t1::TypeRep t2::TypeRep
{
  -- Oberon0 seems to regard each type expression as being distinct.
  -- So the same expression written two places are two different types.
  
  -- However, simply checking equality of names is insufficient,
  -- as it is perfectly reasonable for 'TYPE a = INTEGER' to be equal to
  -- an integer.
  
  -- Thus, we adopt the approach of simply giving unique identifiers to each
  -- array or record expression in the program, and check for equality this way.
  
  -- e.g.
  -- TYPE A = ARRAY 4 OF INTEGER
  -- TYPE B = ARRAY 4 OF INTEGER
  -- A & B are different types.
  
  -- TYPE A = ARRAY 4 OF INTEGER
  -- TYPE B = A
  -- A & B are the same type.
  
  valid <- case t1, t2 of
           | arrayType(_,_,a), arrayType(_,_,b) -> a == b
           | recordType(_,a), recordType(_,b) -> a == b
           | _, _ -> false
           end;
}


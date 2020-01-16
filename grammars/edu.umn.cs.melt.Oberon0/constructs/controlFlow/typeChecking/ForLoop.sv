grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:typeChecking;

imports edu:umn:cs:melt:Oberon0:core; 
imports edu:umn:cs:melt:Oberon0:core:typeChecking;
imports edu:umn:cs:melt:Oberon0:constructs:controlFlow:abstractSyntax;

imports silver:langutil;

aspect production forStmtBy
s::Stmt ::= id::Name lower::Expr upper::Expr step::Expr body::Stmt
{
  s.errors <- if check(lower.type, integerType()) then []
              else [err(lower.location, "Lower bound of FOR loop is not an INTEGER")];
  
  s.errors <- if check(upper.type, integerType()) then []
              else [err(upper.location, "Upper bound of FOR loop is not an INTEGER")];
  
  s.errors <- if check(step.type, integerType()) then []
              else [err(step.location, "Step value of FOR loop is not an INTEGER")];

  s.errors <- case lookupValue(id.name, s.env) of
              | just(dcl) -> if check(dcl.type, integerType()) then []
                             else [err(s.location, "FOR loop variable '" ++ id.name ++ "' is not an INTEGER")]
              | nothing() -> [] -- already handled on Name
              end;
}


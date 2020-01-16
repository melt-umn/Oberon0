grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:typeChecking;

aspect production caseStmt
s::Stmt ::= e::Expr cs::Cases
{
  s.errors <- if !check(e.type, integerType())
              then [err(e.location, "Scrutinee of CASE statement is not an INTEGER")]
              else [];
}

aspect production caseLabel
cl::CaseLabel ::= e::Expr
{
  cl.errors <- checkErrors(e.type, integerType(), "CASE label", e.location);
}
aspect production caseLabelRange
cl::CaseLabel ::= l::Expr u::Expr
{
  cl.errors <- checkErrors(l.type, integerType(), "CASE label lower bound", l.location);
  cl.errors <- checkErrors(u.type, integerType(), "CASE label upper bound", u.location);
}


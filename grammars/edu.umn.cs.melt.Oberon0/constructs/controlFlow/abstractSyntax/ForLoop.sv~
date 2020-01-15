grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:abstractSyntax;

imports edu:umn:cs:melt:Oberon0:core;

imports silver:langutil;
imports silver:langutil:pp as pp;

exports edu:umn:cs:melt:Oberon0:constructs:controlFlow:typeChecking
  with edu:umn:cs:melt:Oberon0:core:typeChecking;

abstract production forStmt
s::Stmt ::= id::Name lower::Expr upper::Expr body::Stmt
{
  s.pp = pp:ppConcat([
    pp:text("FOR "), id.pp, pp:text(" := "), lower.pp, pp:text(" TO "), upper.pp, 
    pp:text(" DO"),
      pp:nestlines(2, body.pp),
    pp:text("DONE")]);

  forwards to forStmtBy(id, lower, upper, number("1", location=id.location), body, location=s.location);
}

abstract production forStmtBy
s::Stmt ::= id::Name lower::Expr upper::Expr step::Expr body::Stmt
{
  s.pp = pp:ppConcat([
    pp:text("FOR "), id.pp, pp:text(" := "), lower.pp, pp:text(" TO "), upper.pp, 
    pp:text(" BY "), step.pp, pp:text(" DO"),
      pp:nestlines(2, body.pp),
    pp:text("DONE")]);

  --T2-start
  s.errors := lower.errors ++ upper.errors ++ step.errors ++ body.errors;

  s.errors <- case lookupValue(id.name, s.env) of
              | just(constDecl(_,_)) -> [err(s.location, "FOR loop variable references a constant, not a variable")]
              | just(dcl) -> []
              | nothing() -> [err(s.location, id.name ++ " is not declared")]
              end;

  s.errors <- if step.evalConstInt.isJust then []
              else [err(step.location, "FOR loop step BY expression must be constant")];
  --T2-end

  -- Choose the comparison operator based on whether we're increasing or decreasing
  local comparison :: Expr=
    if step.evalConstInt.isJust && step.evalConstInt.fromJust < 0 then 
      gte(lExpr(idAccess(id, location=id.location), location=id.location), upper, location=upper.location)
    else
      lte(lExpr(idAccess(id, location=id.location), location=id.location), upper, location=upper.location);

  {- id := lower;
     WHIE id <= upper DO
       body 
       id = id + step;
     END -}
  forwards to
    seqStmt( 
      assign(idAccess(id, location=id.location), lower, location=id.location),
      while(comparison,
        seqStmt(
          body,
          assign(idAccess(id, location=id.location), add(lExpr(idAccess(id, location=id.location), location=id.location), step, location=id.location), location=id.location),
          location=body.location
        ),
        location=s.location
      ),
      location=s.location
    );
}


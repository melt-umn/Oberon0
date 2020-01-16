grammar edu:umn:cs:melt:Oberon0:constructs:controlFlow:abstractSyntax;

abstract production caseStmt
s::Stmt ::= e::Expr cs::Cases
{
  s.pp = pp:ppConcat([
    pp:text("CASE "), e.pp, pp:text(" OF"), pp:line(),
    cs.pp, pp:line(),
    pp:text("END")]);

  s.errors := e.errors ++ cs.errors;  --T2

  cs.caseExpr = e;
  cs.caseNext = skip(location=cs.location);
  forwards to cs.caseTranslation;
}

{--
 - A "higher-order attribute" for constructing an ordinary if-then-else block
 - from the CASE statement body.
 -
 - Type varies with nonterminal: Stmt for most, but Expr for the case labels,
 - where the attribute coresponds to the condition of an IF.
 -}
synthesized attribute caseTranslation<a> :: a;
{--
 - The expression under scrutiny by the CASE statement.
 -}
autocopy attribute caseExpr :: Expr;
{--
 - If this case is not satisfied, what to try next.
 -}
autocopy attribute caseNext :: Stmt;

nonterminal Cases with location, env, errors, pp, caseTranslation<Stmt>, caseExpr, caseNext;

abstract production caseOne
cs::Cases ::= c::Case
{
  cs.pp = c.pp;
  
  cs.caseTranslation = c.caseTranslation;
  cs.errors := c.errors;  --T2
}
abstract production caseCons
cs::Cases ::= c::Case rest::Cases
{
  cs.pp = pp:ppConcat([
    c.pp, pp:line(),
    case rest of 
    | caseOne(caseElse(_)) -> rest.pp
    | _ -> pp:cat(pp:text("| "), rest.pp)
    end ]);
  --T2-start  
  cs.caseTranslation = c.caseTranslation;
  c.caseNext = rest.caseTranslation;
  cs.errors := c.errors ++ rest.errors;
  --T2-end
}

nonterminal Case with location, env, errors, pp, caseTranslation<Stmt>, caseExpr, caseNext;

abstract production caseClause
c::Case ::= cls::CaseLabels s::Stmt
{
  c.pp = pp:ppConcat([cls.pp, pp:text(" : "), s.pp]);
  
  c.caseTranslation = cond(cls.caseTranslation, s, c.caseNext, location=c.location);
  c.errors := cls.errors ++ s.errors;  --T2
}
abstract production caseElse
c::Case ::= s::Stmt
{
  c.pp = pp:cat(pp:text("ELSE "), s.pp);
  
  c.caseTranslation = s;
  c.errors := s.errors;  --T2
}

nonterminal CaseLabels with location, env, errors, pp, caseTranslation<Expr>, caseExpr;

abstract production oneCaseLabel
cls::CaseLabels ::= cl::CaseLabel
{
  cls.pp = cl.pp;
  
  cls.caseTranslation = cl.caseTranslation;
  cls.errors := cl.errors;  --T2
}
abstract production consCaseLabel
cls::CaseLabels ::= cl::CaseLabel rest::CaseLabels
{
  cls.pp = pp:ppConcat([cl.pp, pp:text(", "), rest.pp]);
  
  cls.caseTranslation = or(cl.caseTranslation, rest.caseTranslation, location=cls.location);
  cls.errors := cl.errors ++ rest.errors;  --T2
}

nonterminal CaseLabel with location, env, errors, pp, caseTranslation<Expr>, caseExpr;

abstract production caseLabel
cl::CaseLabel ::= e::Expr
{
  cl.pp = e.pp;
  
  cl.caseTranslation = eq(cl.caseExpr, e, location=cl.location);
  --T2-start
  cl.errors := e.errors;

  cl.errors <- if e.evalConstInt.isJust then []
               else [err(e.location, "CASE label " ++ pp:show(100, e.pp) ++ " is not a constant")];
  --T2-end
}
abstract production caseLabelRange
cl::CaseLabel ::= l::Expr u::Expr
{
  cl.pp = pp:ppConcat([l.pp, pp:text(".."), u.pp]);
  
  cl.caseTranslation = Oberon0_Expr { $Expr{cl.caseExpr} >= $Expr{l} & $Expr{cl.caseExpr} <= $Expr{u} };

  --T2-start
  cl.errors := l.errors ++ u.errors;

  cl.errors <- if l.evalConstInt.isJust then []
               else [err(l.location, "CASE label lower bound " ++ pp:show(100, l.pp) ++ " is not a constant")];
  cl.errors <- if u.evalConstInt.isJust then []
               else [err(u.location, "CASE label lower bound " ++ pp:show(100, u.pp) ++ " is not a constant")];
  --T2-end
}


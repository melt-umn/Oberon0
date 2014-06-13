grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Stmt with location, pp,
  env, errors;  --T2

abstract production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{
  s.pp = pp:concat([s1.pp, pp:semi(), pp:line(), s2.pp]);
  
  s.errors := s1.errors ++ s2.errors;  --T2
}


abstract production skip
s::Stmt ::=
{
  s.pp = pp:notext();
  
  s.errors := [];  --T2
}

abstract production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.pp = pp:concat([l.pp, pp:text(" := "), e.pp]);
  --T2-start  
  s.errors := l.errors ++ e.errors;
  s.errors <- if !l.evalConstInt.isJust then []
              else [err(l.location, "Cannot assign to the constant " ++ pp:show(100, l.pp))];
  --T2-end
}

abstract production cond
s::Stmt ::= c::Expr t::Stmt e::Stmt
{
  s.pp = pp:concat([pp:text("IF "), c.pp, pp:text(" THEN"),
    pp:nestlines(2, t.pp),
    case e of 
    | skip() -> pp:text("END")
    | cond(_,_,_) -> pp:cat(pp:text("ELS"), e.pp)
    | _ -> pp:concat([pp:text("ELSE"), pp:nestlines(2, e.pp), pp:text("END")])
    end]);
  
  s.errors := c.errors ++ t.errors ++ e.errors;  --T2
}

abstract production while
s::Stmt ::= con::Expr body::Stmt
{
  s.pp = pp:concat([pp:text("WHILE "), con.pp, pp:text(" DO"),
           pp:nestlines(2, body.pp),
         pp:text("END")]);
  
  s.errors := con.errors ++ body.errors;  --T2
}

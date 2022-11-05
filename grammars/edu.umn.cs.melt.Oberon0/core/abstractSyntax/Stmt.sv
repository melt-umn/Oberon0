grammar edu:umn:cs:melt:Oberon0:core:abstractSyntax;

nonterminal Stmt with location, pp,
  env, errors;  --T2

propagate errors, env on Stmt;  --T2

abstract production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{
  s.pp = pp:ppConcat([s1.pp, pp:semi(), pp:line(), s2.pp]);
}


abstract production skip
s::Stmt ::=
{
  s.pp = pp:notext();
}

abstract production assign
s::Stmt ::= l::LExpr e::Expr
{
  s.pp = pp:ppConcat([l.pp, pp:text(" := "), e.pp]);
  --T2-start
  s.errors <- if !l.evalConstInt.isJust then []
              else [err(l.location, "Cannot assign to the constant " ++ pp:show(100, l.pp))];
  --T2-end
}

abstract production cond
s::Stmt ::= c::Expr t::Stmt e::Stmt
{
  s.pp = pp:ppConcat([pp:text("IF "), c.pp, pp:text(" THEN"),
    pp:nestlines(2, t.pp),
    case e of 
    | skip() -> pp:text("END")
    | cond(_,_,_) -> pp:cat(pp:text("ELS"), e.pp)
    | _ -> pp:ppConcat([pp:text("ELSE"), pp:nestlines(2, e.pp), pp:text("END")])
    end]);
}

abstract production while
s::Stmt ::= con::Expr body::Stmt
{
  s.pp = pp:ppConcat([pp:text("WHILE "), con.pp, pp:text(" DO"),
           pp:nestlines(2, body.pp),
         pp:text("END")]);
}

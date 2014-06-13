grammar edu:umn:cs:melt:Oberon0:tasks:codegenC:procedures;

import edu:umn:cs:melt:Oberon0:constructs:procedures:typeChecking;

attribute cTrans occurs on Exprs;

aspect production call
s::Stmt ::= f::Name a::Exprs
{
  s.cTrans = f.name ++ "(" ++ a.cTrans ++ "); \n";
}

aspect production nilExprs
es::Exprs ::=
{
  es.cTrans = "";
}


aspect production consExprs
es::Exprs ::= e::Expr rest::Exprs
{
  es.cTrans = let here :: String = 
                    case es.paramsKnown of
                    | just(pair(_,h)::_) -> if h.passedByValue then e.cTrans else "&(" ++ e.cTrans ++ ")"
                    end,
                  next :: String = 
                    case rest of 
                    | nilExprs() -> ""
                    | _ -> ", " ++ rest.cTrans
                    end
               in here ++ next end;
}

aspect production readCall
s::Stmt ::= f::Name e::Exprs
{
  s.cTrans = "scanf(\"%d\", " ++ e.cTrans ++ ");\n";
}
aspect production writeCall
s::Stmt ::= f::Name e::Exprs
{
  s.cTrans = "printf(\" %d\", " ++ e.cTrans ++ ");\n";
}
aspect production writeLnCall
s::Stmt ::= f::Name e::Exprs
{
  s.cTrans = "printf(\"\\n\");\n";
}


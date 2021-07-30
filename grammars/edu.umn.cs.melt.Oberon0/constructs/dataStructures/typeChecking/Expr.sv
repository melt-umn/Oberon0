grammar edu:umn:cs:melt:Oberon0:constructs:dataStructures:typeChecking;


aspect production arrayAccess
e::LExpr ::= array::LExpr index::Expr
{
  e.type = case array.type of
           | arrayType(_, ty1,_) -> ty1
           | _ -> errorType()
           end;
  e.errors <- if check(index.type, integerType()) then []
              else [err(index.location, "Array index is not an integer")];
  e.errors <- 
    case index.evalConstInt, array.type of
    | nothing(), arrayType(_,_,_) -> []
    | just(x), arrayType(fe,_,_) ->
        case fe.evalConstInt of
        | nothing() -> [] -- error there!
        | just(y) -> if y > x then if x >= 0 then []
                                   else [err(index.location, "Negative array index!")]
                     else [err(index.location, "Array index exceeds array size")]
        end
    | _, _ -> [err(array.location, pp:show(100, array.pp) ++ " is not an array")]
    end;
}

aspect production fieldAccess
e::LExpr ::= rec::LExpr fld::Name
{
  {- Name will want to look up field names, which requires doing enough
     type checking to determine the type of `rec`.  We use the threading
     of `env` and `newEnv` to create the new env.
  -}
  fld.env =
    case rec.type of
    | recordType(decls,_) -> 
          (decorate new(decls) with {env = emptyEnv();}).newEnv
    | _ -> emptyEnv()
    end;

  e.type =
    case rec.type of
    | recordType(decls,_) -> case lookup(fld.name, decls.vars) of
                             | just(ty1) -> ty1.type
                             | _ -> errorType()
                             end
    | _ -> errorType()
    end;

  e.errors <- 
    case rec.type of
    | recordType(decls,_) ->
        case lookup(fld.name, decls.vars) of
        | just(ty1) -> []
        | _ -> [err(rec.location, pp:show(100, rec.pp) ++ " does not contain a field called " ++ fld.name)]
        end
    | _ -> [err(rec.location, pp:show(100, rec.pp) ++ " is not a record type")]
    end;
}


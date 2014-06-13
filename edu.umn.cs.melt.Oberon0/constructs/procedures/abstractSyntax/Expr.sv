grammar edu:umn:cs:melt:Oberon0:constructs:procedures:abstractSyntax;

aspect production idAccess
e::LExpr ::= id::Name
{
  {--
   - A (possibly less than ideal) way of turning off the error check for
   - referring to variables in scopes other than Module-level or
   - most-local scope.
   -}
  production attribute permitOnlyTopLevelAndLocalAccess :: Boolean with &&;
  permitOnlyTopLevelAndLocalAccess := true;
  
  e.errors <- 
    if !permitOnlyTopLevelAndLocalAccess 
    then [] 
    else
      case id.lookupName of
      | nothing() -> []
      | just(constDecl(_,_)) -> []
      | just(v) -> 
          if ! v.enclosingProcedure.isJust ||
             lookupValueInScope(id.name, e.env).isJust 
          then []
          else [err(e.location, "Value " ++ id.name ++ " is not accessible here")]
              end;
}

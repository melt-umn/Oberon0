grammar edu:umn:cs:melt:Oberon0:core:driver;

import edu:umn:cs:melt:Oberon0:core:concreteSyntax;
import edu:umn:cs:melt:Oberon0:core:abstractSyntax;

import silver:langutil;

-- Parse given .ob file and collect errors
-- fileContents: The contents of the file to parse (a string)
-- fileName: Name of the file to parse
-- parse: The parse function to use
function lspDriver
[Message] ::= fileContents::String
           fileName::String
           parse::(ParseResult<Module_c> ::= String String) {
  local result :: ParseResult<Module_c> = parse(fileContents, fileName);
  local cst :: Module_c = result.parseTree;
  production ast :: Module = cst.ast;

  return 
    if !result.parseSuccess then
      case result.parseError of
        | syntaxError(str, locat, _, _) ->
              [err(locat,
                "Syntax error:\n" ++ str)]
        | unknownParseError(str, file) ->
              [err(loc(file, -1, -1, -1, -1, -1, -1),
                "Unknown error while parsing:\n" ++ str)]
      end
    else ast.errors;

}
grammar edu:umn:cs:melt:Oberon0:core:driver;

import edu:umn:cs:melt:Oberon0:core:concreteSyntax;
import edu:umn:cs:melt:Oberon0:core:abstractSyntax;

import silver:langutil;
import silver:langutil:pp as pp;

{--
 - Do the compiler's I/O.
 -
 - Silver's IO support isn't all that great.
 -
 - @param args  The command line arguments
 - @param parse  The parse function to use
 - @param driverIO  The incoming IO token (used to sequence actions)
 -}
function driver
IOVal<Integer> ::= args::[String]
                   parse::(ParseResult<Module_c> ::= String String)
                   driverIO::IOToken
{
  production filename :: String = head(args);
  local fileExists :: IOVal<Boolean> = isFileT(filename, driverIO);
  local text :: IOVal<String> = readFileT(filename,fileExists.io);
  local result :: ParseResult<Module_c> = parse(text.iovalue, filename);
  local cst :: Module_c = result.parseTree;
  production ast :: Module = cst.ast;

  -- This is a list of tasks to perform, see the task grammars in components/
  production attribute tasks::[Task] with ++;
  tasks :=
    [writePPTask(filename, ast), 
     writeErrorsTask(filename, ast),
     displayErrorLineNum(ast)];

  local allTasks :: Task = concatTasks(tasks);
  allTasks.tioIn = text.io;

  return
    if null(args)
    then ioval(printT("No required command line arguments provided.\n", driverIO), 1)
    else
    if !fileExists.iovalue
    then ioval(printT("File \"" ++ filename ++ "\" not found.\n\n", fileExists.io), 1)
    else
    if !result.parseSuccess 
    then ioval(printT("parse failed.\n" ++ result.parseErrors ++ "\n", text.io), 1)
    else ioval(allTasks.tioOut, 0);
}

closed nonterminal Task with tioIn, tioOut;

inherited attribute tioIn :: IOToken;
synthesized attribute tioOut :: IOToken;

{- Actually used tasks -}

abstract production writePPTask
t::Task ::= filename::String p_ast::Decorated Module
{ 
  local filenamePP::String = substring(0, length(filename)-3, filename) ++ "_pp.ob";

  t.tioOut = writeFileT(filenamePP, pp:show(79,p_ast.pp), t.tioIn);
}
abstract production writeErrorsTask
t::Task ::= filename::String p_ast::Decorated Module
{
  local filenameErrors::String = substring(0, length(filename)-3, filename) ++ ".errors";

  t.tioOut = writeFileT(filenameErrors,
                       messagesToString(p_ast.errors) ++ "\n\n",
                       t.tioIn);
}
abstract production displayErrorLineNum
t::Task ::= p_ast::Decorated Module
{
  t.tioOut = if null(p_ast.errors)
             then t.tioIn
             else printT(toString(head(sortBy(messageLte, p_ast.errors)).where.line) ++ "\n\n", t.tioIn);
}

{- Examples of other tasks -}

abstract production printPPTask
t::Task ::= filename::String p_ast::Decorated Module
{
  t.tioOut = printT("Pretty print of program in \"" ++ filename ++ "\":\n" ++
                   pp:show(79, p_ast.pp) ++ "\n\n", t.tioIn);
}
abstract production printErrorsTask
t::Task ::= filename::String p_ast::Decorated Module
{
  t.tioOut = printT("Errors of program in \"" ++ filename ++ "\":\n" ++
                   messagesToString(p_ast.errors) ++ 
                   "\n\n", t.tioIn );
}


abstract production concatTasks
t::Task ::= ts::[Task]
{ t.tioOut = if null(ts) then t.tioIn else rest.tioOut;

  local first::Task = head(ts);
  first.tioIn = t.tioIn;

  local rest::Task = concatTasks(tail(ts));
  rest.tioIn = first.tioOut;
}




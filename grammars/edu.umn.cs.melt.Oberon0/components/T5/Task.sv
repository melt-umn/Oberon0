grammar edu:umn:cs:melt:Oberon0:components:T5;

exports edu:umn:cs:melt:Oberon0:tasks:lift:core;
exports edu:umn:cs:melt:Oberon0:tasks:codegenC:core;

import edu:umn:cs:melt:Oberon0:core:driver;
import edu:umn:cs:melt:Oberon0:core;

import silver:langutil;
import silver:langutil:pp as pp;

aspect function driver
IOVal<Integer> ::= args::[String]
                   parse::(ParseResult<Module_c> ::= String String)
                   driverIO::IOToken
{
 tasks <- [writeC(filename, ast)];
}

abstract production writeC
t::Task ::= filename::String ast::Decorated Module
{
  local base_filename :: String =
    substring(0, length(filename)-3, filename);

  -- Strictly speaking, this is just fine, and one lifting step is enough.
  local liftedast :: Module = ast.lifted;
  
  -- HOWEVER, the lifting procedure does: 1. Unique renaming  2. "Lambda lifting"
  -- The problem is, #2 may cause some names to no longer be unique.
  -- So, we will do lifting again, thus ensuring everything is unique again.
  -- This isn't *necessary*, it's just to ensure the idempotency of the
  -- lifting transformation, for the benefit of our test harness, which checks this.
  local liftedast2 :: Module = liftedast.lifted;

  local writelifted :: IOToken = 
    if null(liftedast.errors) -- For debugging purposes, if the lifting caused errors, write that out!
    then writeFileT(base_filename ++ "_lifted.ob", pp:show(100, liftedast2.pp), t.tioIn)
    else writeFileT(base_filename ++ "_lifted.ob", pp:show(100, liftedast.pp), t.tioIn);

  local writecfile :: IOToken = 
    if null(liftedast.errors) -- Again, for debugging.
    then writeFileT(base_filename ++ ".c", liftedast2.cTrans, writelifted)
         -- This will cause the compiler to crash, usefully:
    else unsafeTrace(error(messagesToString(liftedast.errors)), writelifted);

 -- If there were errors in the original AST, skip this whole task
  t.tioOut = if null(ast.errors) then writecfile else t.tioIn;
}


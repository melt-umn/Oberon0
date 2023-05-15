# oberon0lsp README

This extension provides language server protocol-based editor features for Oberon0.
It serves as an initial example for how to create a language server and protocol interface for languages implemented in Silver.

## Features

* Semantic token-based syntax highlighting, powered by [Copper](https://melt.cs.umn.edu/copper)
* Diagnostic error reporting
* View / jump to declarationDescribe specific features of your extension including screenshots of your extension in action. Image paths are relative to this README file.

## Requirements

Running this extension requires Java 11.  Issues have been noted with newer versions of Java.

## Extension Settings

This extension contributes the following settings:

* `Oberon0.compilerJar`: Path to a jar file containing an alternate version of the Oberon0 compiler
* `Oberon0.parserName`: Full name of the Oberon0 parser to use, must be set if compiler jar is specified

## Known Issues

The use of Copper for semantic tokens means that in case of a syntax error, highlighting is not shown for the rest of the file after the syntax error.
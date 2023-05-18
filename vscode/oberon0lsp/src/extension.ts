import * as path from 'path';
import * as vscode from 'vscode';

// Import the language client, language client options and server options from VSCode language client.
import { LanguageClient, LanguageClientOptions, ServerOptions } from 'vscode-languageclient/node';

let client: LanguageClient;

// Name of the launcher class which contains the main.
const main: string = 'StdioLauncher';

export function activate(context: vscode.ExtensionContext) {
	console.log('Congratulations, your extension "oberon0lsp" is now active!');

	// Get the java home from the process environment.
	const { JAVA_HOME } = process.env;

	// Get the config settings
	const config = vscode.workspace.getConfiguration("Oberon0");

	console.log(`Using java from JAVA_HOME: ${JAVA_HOME}`);
	// If java home is available continue.
	if (JAVA_HOME) {
		// Java execution path.
		let excecutable: string = path.join(JAVA_HOME, 'bin', 'java');

		// path to the launcher.jar
		let classPath = path.join(__dirname, '..', 'launcher', 'launcher.jar');
		const args: string[] = [
			'-cp', classPath,
		];

		// Set the server options 
		// -- java execution path
		// -- argument to be pass when executing the java command
		let serverOptions: ServerOptions = {
			command: excecutable,
			args: [...args, main],
			options: {}
		};

		// Options to control the language client
		let clientOptions: LanguageClientOptions = {
			documentSelector: [{ scheme: 'file', language: 'Oberon0' }],
			synchronize: {
				configurationSection: 'Oberon0'
			},
			initializationOptions: {
				'compilerJar': config.get('compilerJar'),
				'parserName': config.get('parserName'),
        'initGrammar': config.get('initGrammar')
			}
		};

		// Create the language client and start the client.
		console.log("Launching language server");
		client = new LanguageClient('oberon0-langserver', 'Language Support for Oberon0', serverOptions, clientOptions);

		client.start();
	}
}

// this method is called when your extension is deactivated
export function deactivate() { 
	console.log('Your extension "oberon0lsp" is now deactivated!');
	if (!client) {
		return undefined;
	}
	return client.stop();
}
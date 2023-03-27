package edu.umn.cs.melt.oberon0.langserver;

import org.eclipse.lsp4j.services.LanguageServer;

public class Oberon0LanguageServer implements LanguageServer {

  @Override
	public CompletableFuture<InitializeResult> initialize(InitializeParams params) {
		throw new UnsupportedOperationException();
	}

	@Override
	public CompletableFuture<Object> shutdown() {
		throw new UnsupportedOperationException();
	}

	@Override
	public void exit() {
	}

	@Override
	public TextDocumentService getTextDocumentService() {
		return this;
	}

	@Override
	public WorkspaceService getWorkspaceService() {
		return this;
	}

	@Override
	public void didOpen(DidOpenTextDocumentParams params) {
	}

	@Override
	public void didChange(DidChangeTextDocumentParams params) {
	}

	@Override
	public void didClose(DidCloseTextDocumentParams params) {
	}

	@Override
	public void didSave(DidSaveTextDocumentParams params) {
	}

}
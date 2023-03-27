package edu.umn.cs.melt.oberon0.langserver;

import java.util.concurrent.CompletableFuture;

import org.eclipse.lsp4j.InitializeParams;
import org.eclipse.lsp4j.InitializeResult;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.LanguageClientAware;
import org.eclipse.lsp4j.services.LanguageServer;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;


public class Oberon0LanguageServer implements LanguageServer, LanguageClientAware {

  private Oberon0LanguageService service;
  private LanguageClient client;

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
		return this.service;
	}

	@Override
	public WorkspaceService getWorkspaceService() {
		return this.service;
	}

  @Override
  public void connect(LanguageClient languageClient) {
    this.client = languageClient;
    service.setClient(languageClient);
  }

}
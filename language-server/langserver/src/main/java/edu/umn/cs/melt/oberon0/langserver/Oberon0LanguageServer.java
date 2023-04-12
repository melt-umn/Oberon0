package edu.umn.cs.melt.oberon0.langserver;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.eclipse.lsp4j.InitializeParams;
import org.eclipse.lsp4j.InitializeResult;
import org.eclipse.lsp4j.MessageParams;
import org.eclipse.lsp4j.MessageType;
import org.eclipse.lsp4j.SemanticTokensLegend;
import org.eclipse.lsp4j.SemanticTokensServerFull;
import org.eclipse.lsp4j.SemanticTokensWithRegistrationOptions;
import org.eclipse.lsp4j.ServerCapabilities;
import org.eclipse.lsp4j.TextDocumentSyncKind;
import org.eclipse.lsp4j.WorkspaceFolder;

import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.LanguageClientAware;
import org.eclipse.lsp4j.services.LanguageServer;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;

import com.google.gson.JsonObject;

import edu.umn.cs.melt.lsp4jutil.Util;
import edu.umn.cs.melt.Oberon0.core.concreteSyntax.NModule_c;

public class Oberon0LanguageServer implements LanguageServer, LanguageClientAware {

  private Oberon0LanguageService service;
  private LanguageClient client;

  public Oberon0LanguageServer() {
    this.service = new Oberon0LanguageService();
  }

  @Override
	public CompletableFuture<InitializeResult> initialize(InitializeParams initializeParams) {
		System.err.println("Initializing Oberon0 language server");

    // Initialize the runtime
    common.Util.init();

    // Get the initialization options
    String compilerJar = "", parserName = "";
    try {
        JsonObject initOptions = (JsonObject)initializeParams.getInitializationOptions();
        if (initOptions != null) {
            if (initOptions.has("compilerJar")) {
                compilerJar = initOptions.get("compilerJar").getAsString();
            }
            if (initOptions.has("parserName")) {
                parserName = initOptions.get("parserName").getAsString();
            }
        }
    } catch(ClassCastException e) {
        System.err.println("Got unexpected init options: " + initializeParams.getInitializationOptions());
    }
    if (parserName.isEmpty()) {
        parserName = "edu:umn:cs:melt:Oberon0:components:L4:parse";
    }

    // Initialize grammars from the specified compiler jar (or default classloader)
    ClassLoader loader = ClassLoader.getSystemClassLoader();

    if (!compilerJar.isEmpty()) {
      List<WorkspaceFolder> workspaceFolders = initializeParams.getWorkspaceFolders();
      Path jarPath;
      try {
          // Compute the absolute jar path based on the workspace folder, if a relative path is specified.
          jarPath = workspaceFolders != null && workspaceFolders.size() > 0?
              Paths.get(new URI(initializeParams.getWorkspaceFolders().get(0).getUri()).getPath()).resolve(compilerJar) :
              Paths.get(compilerJar);
      } catch (URISyntaxException e) {
        throw new RuntimeException(e);
      }
      loader = Util.getJarClassLoader(jarPath);
    }

    // Load the specified parser
    boolean loadedParser = false;
    try {
        service.setParserFactory(Util.loadCopperParserFactory(loader, parserName, NModule_c.class));
        loadedParser = true;
    } catch (SecurityException | ReflectiveOperationException e) {
        client.showMessage(new MessageParams(MessageType.Error, "Error loading parser " + parserName + " from jar: " + e.toString()));
    }

    // Set up the Oberon0 grammars folder?
    Path oberon0Grammars;
    try {
        oberon0Grammars = Files.createTempDirectory("oberon0_grammars");
        Util.copyFromJar(getClass(), "grammars/", oberon0Grammars);
    } catch (IOException | URISyntaxException e) {
        throw new RuntimeException(e);
    }
    service.setOberon0GrammarsPath(oberon0Grammars);

    // Set the capabilities of the LS to inform the client.
    ServerCapabilities capabilities = new ServerCapabilities();
    capabilities.setTextDocumentSync(TextDocumentSyncKind.Full);
    if (loadedParser) {
        capabilities.setSemanticTokensProvider(
            new SemanticTokensWithRegistrationOptions(
                new SemanticTokensLegend(
                    Oberon0LanguageService.tokenTypes, Oberon0LanguageService.tokenModifiers),
                new SemanticTokensServerFull(false), false));
    }

    final InitializeResult initializeResult = new InitializeResult(capabilities);
    return CompletableFuture.supplyAsync(()->initializeResult);

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

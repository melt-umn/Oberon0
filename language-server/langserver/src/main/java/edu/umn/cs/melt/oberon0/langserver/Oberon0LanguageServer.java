package edu.umn.cs.melt.oberon0.langserver;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.eclipse.lsp4j.FileOperationFilter;
import org.eclipse.lsp4j.FileOperationOptions;
import org.eclipse.lsp4j.FileOperationPattern;
import org.eclipse.lsp4j.FileOperationsServerCapabilities;
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
import org.eclipse.lsp4j.WorkspaceServerCapabilities;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.LanguageClientAware;
import org.eclipse.lsp4j.services.LanguageServer;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;

import com.google.gson.JsonObject;

import edu.umn.cs.melt.Oberon0.core.concreteSyntax.NModule_c;
import edu.umn.cs.melt.lsp4jutil.Util;

public class Oberon0LanguageServer implements LanguageServer, LanguageClientAware {

  private Oberon0LanguageService service;
  private LanguageClient client;
  private int errorCode = 1;

  public Oberon0LanguageServer() {
    this.service = new Oberon0LanguageService();
  }

  @Override
	public CompletableFuture<InitializeResult> initialize(InitializeParams initializeParams) {
		System.err.println("Initializing Oberon0 language server");

    // Initialize the runtime
    common.Util.init();

    // Get the initialization options
    String compilerJar = "", parserName = "", initGrammar = "";
    try {
        JsonObject initOptions = (JsonObject)initializeParams.getInitializationOptions();
        if (initOptions != null) {
            if (initOptions.has("compilerJar")) {
                compilerJar = initOptions.get("compilerJar").getAsString();
            }
            if (initOptions.has("parserName")) {
                parserName = initOptions.get("parserName").getAsString();
            }
            if (initOptions.has("initGrammar")) {
                initGrammar = initOptions.get("initGrammar").getAsString();
            }
        }
    } catch(ClassCastException e) {
        System.err.println("Got unexpected init options: " + initializeParams.getInitializationOptions());
    }
    if (parserName.isEmpty()) {
        // Default parser
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

    // Initialize Oberon0 grammars
    if (initGrammar.isEmpty()){
      // Default initialization grammar
      // Must include both parser & driver
      initGrammar = "edu:umn:cs:melt:Oberon0:artifacts:A5";
    }
    try {
        Util.initGrammar(initGrammar, loader);
    } catch (SecurityException | ReflectiveOperationException e) {
        client.showMessage(new MessageParams(MessageType.Error, "Error loading compiler jar " + compilerJar + ": " + e.toString()));
    }

    // Load the specified parser
    boolean loadedParser = false;
    try {
        service.setParserFactory(Util.loadCopperParserFactory(loader, parserName, NModule_c.class));
        loadedParser = true;
    } catch (SecurityException | ReflectiveOperationException e) {
        client.showMessage(new MessageParams(MessageType.Error, "Error loading parser " + parserName + " from jar: " + e.toString()));
    }

    // Initialize the project folder(s)
    if (initializeParams.getWorkspaceFolders() != null) {
        service.setWorkspaceFolders(initializeParams.getWorkspaceFolders());
    }

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

    capabilities.setDeclarationProvider(true);

    FileOperationOptions fileOperationOptions = new FileOperationOptions(
        List.of(new FileOperationFilter(new FileOperationPattern("**/*.ob")))
    );
    FileOperationsServerCapabilities fileOperations = new FileOperationsServerCapabilities();
    fileOperations.setDidCreate(fileOperationOptions);
    fileOperations.setDidDelete(fileOperationOptions);
    fileOperations.setDidRename(fileOperationOptions);
    WorkspaceServerCapabilities workspaceServer = new WorkspaceServerCapabilities();
    workspaceServer.setFileOperations(fileOperations);
    capabilities.setWorkspace(workspaceServer);

    final InitializeResult initializeResult = new InitializeResult(capabilities);
    return CompletableFuture.supplyAsync(()->initializeResult);

	}

	@Override
	public CompletableFuture<Object> shutdown() {
    // If shutdown request comes from client, set the error code to 0.
    errorCode = 0;
    return null;	
  }

	@Override
	public void exit() {
    // Kill the LS on exit request from client.
    System.exit(errorCode);
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

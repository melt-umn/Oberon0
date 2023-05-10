package edu.umn.cs.melt.oberon0.langserver;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import org.eclipse.lsp4j.CreateFilesParams;
import org.eclipse.lsp4j.DeclarationParams;
import org.eclipse.lsp4j.DeleteFilesParams;
import org.eclipse.lsp4j.DidChangeConfigurationParams;
import org.eclipse.lsp4j.DidChangeTextDocumentParams;
import org.eclipse.lsp4j.DidChangeWatchedFilesParams;
import org.eclipse.lsp4j.DidCloseTextDocumentParams;
import org.eclipse.lsp4j.DidOpenTextDocumentParams;
import org.eclipse.lsp4j.DidSaveTextDocumentParams;
import org.eclipse.lsp4j.Location;
import org.eclipse.lsp4j.LocationLink;
import org.eclipse.lsp4j.PublishDiagnosticsParams;
import org.eclipse.lsp4j.RenameFilesParams;
import org.eclipse.lsp4j.SemanticTokens;
import org.eclipse.lsp4j.SemanticTokensParams;
import org.eclipse.lsp4j.TextDocumentContentChangeEvent;
import org.eclipse.lsp4j.WorkspaceFolder;
import org.eclipse.lsp4j.jsonrpc.CompletableFutures;
import org.eclipse.lsp4j.jsonrpc.messages.Either;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;

import common.ConsCell;
import common.DecoratedNode;
import common.OriginContext;
import common.SilverCopperParser;
import common.StringCatter;
import common.javainterop.ConsCellCollection;
import edu.umn.cs.melt.Oberon0.core.concreteSyntax.NModule_c;
import edu.umn.cs.melt.Oberon0.core.driver.PlspDriver;
import edu.umn.cs.melt.Oberon0.langserver.PfindDeclLocation;
import edu.umn.cs.melt.lsp4jutil.CopperParserNodeFactory;
import edu.umn.cs.melt.lsp4jutil.CopperSemanticTokenEncoder;
import edu.umn.cs.melt.lsp4jutil.Util;
import silver.core.NLocation;
import silver.core.NPair;


public class Oberon0LanguageService implements TextDocumentService, WorkspaceService {

  private LanguageClient client;
  private List<WorkspaceFolder> folders;
  private Map<String, String> fileContents = new HashMap<>();
  private Map<String, Integer> fileVersions = new HashMap<>();
  private Set<URI> buildFiles = new HashSet<>();
  private Map<String, Integer> savedVersions = new HashMap<>();
  private Map<String, Object> savedModules = new HashMap<>();

  public Oberon0LanguageService() {}

  public void setClient(LanguageClient client) {
    this.client = client;
  }

  public void setWorkspaceFolders(List<WorkspaceFolder> folders) {
      this.folders = folders;
      refreshWorkspace();
  }

	@Override
	public void didOpen(DidOpenTextDocumentParams params) {
    //System.err.println("Opened " + params);
    String uri = params.getTextDocument().getUri();
    fileContents.put(uri, params.getTextDocument().getText());
    fileVersions.put(uri, params.getTextDocument().getVersion());
    savedVersions.put(uri, params.getTextDocument().getVersion());
    doBuild(URI.create(uri));
	}

	@Override
	public void didChange(DidChangeTextDocumentParams params) {
    //System.err.println("Changed " + params);
    String uri = params.getTextDocument().getUri();
    for (TextDocumentContentChangeEvent change : params.getContentChanges()) {
        fileContents.put(uri, change.getText());
        fileVersions.put(uri, params.getTextDocument().getVersion());
    }
	}

	@Override
	public void didClose(DidCloseTextDocumentParams params) {
    //System.err.println("Closed " + params);
    String uri = params.getTextDocument().getUri();
    fileContents.remove(uri);
    fileVersions.remove(uri);
    savedVersions.remove(uri);
	}

	@Override
	public void didSave(DidSaveTextDocumentParams params) {
    //System.err.println("Saved " + params);
    String uri = params.getTextDocument().getUri();
    if (!fileVersions.containsKey(uri)) {
        throw new IllegalStateException("File saved before it was changed");
    }
    savedVersions.put(uri, fileVersions.get(uri));
    doBuild(URI.create(uri));
	}

  @Override
  public void didChangeConfiguration(DidChangeConfigurationParams params) {

  }

  @Override
  public void didChangeWatchedFiles(DidChangeWatchedFilesParams params) {

  }
  
  @Override
  public void didCreateFiles(CreateFilesParams params) {
    refreshWorkspace();
  }

  @Override
  public void didDeleteFiles(DeleteFilesParams params) {
    refreshWorkspace();
  }

  @Override
  public void didRenameFiles(RenameFilesParams params) {
    refreshWorkspace();
  }

  @Override
  public CompletableFuture<Either<List<? extends Location>, List<? extends LocationLink>>> declaration(DeclarationParams params) {
    return CompletableFutures.computeAsync((cancelChecker) -> {
      String fileName = "";
      try {
          fileName = new URI(params.getTextDocument().getUri()).getPath();
      } catch (URISyntaxException e) {
          e.printStackTrace();
      }
      if (savedModules.get(fileName) == null) {
        System.err.println("No modules saved for " + fileName);
        return Either.forLeft(List.of());
      }

      return Either.forLeft(new ConsCellCollection<NLocation>(
          PfindDeclLocation.invoke(OriginContext.FFI_CONTEXT,
          new StringCatter(fileName), 
          params.getPosition().getLine() + 1, params.getPosition().getCharacter(), 
          savedModules.get(fileName)))
          .stream()
          .map((loc) -> new Location("file://" + Util.locationToFile(loc), Util.locationToRange(loc)))
          .collect(Collectors.toList()));
    });
  }

  public static final List<String> tokenTypes = Arrays.asList(new String[] {
      "namespace", "type", "interface", "class", "typeParameter", "parameter", "variable", "function",
      "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "struct"
  });
  public static final List<String> tokenModifiers = Arrays.asList(new String[] {
      "declaration", "definition", "documentation", "defaultLibrary", "modification"
  });

  private CopperSemanticTokenEncoder semanticTokenEncoder = null;
  private CopperParserNodeFactory parserFn = null;
  public void setParserFactory(Supplier<SilverCopperParser<NModule_c>> parserFactory) {
      semanticTokenEncoder = new CopperSemanticTokenEncoder(parserFactory, tokenTypes, tokenModifiers);
      parserFn = new CopperParserNodeFactory(parserFactory);
  }

  @Override
  public CompletableFuture<SemanticTokens> semanticTokensFull(SemanticTokensParams params) {
      if (semanticTokenEncoder == null) {
          throw new IllegalStateException("Semantic tokens requested when parser has not been initialized");
      }

      String uri = params.getTextDocument().getUri();

      return CompletableFutures.computeAsync((cancelChecker) -> {
          List<Integer> tokens;
          int requestVersion;
          do {
              requestVersion = fileVersions.get(uri);
              if (fileContents.containsKey(uri)) {
                  tokens = semanticTokenEncoder.parseTokens(fileContents.get(uri));
              } else {
                  tokens = new ArrayList<Integer>();
              }
          } while (requestVersion != fileVersions.get(uri));
          return new SemanticTokens(tokens);
      });
  }

  private void refreshWorkspace() {
      buildFiles.clear();

      for (WorkspaceFolder folder : folders) {
          URI uri;
          try {
              uri = new URI(folder.getUri());
          } catch (URISyntaxException e) {
              throw new IllegalArgumentException("Invalid URI", e);
          }
          findObFiles(new File(uri));
      }

      Runnable buildAll = () -> {
        System.err.println("Building workspace files");
        for (URI uri : buildFiles) {
          doBuild(uri);
        } 
      };

      CompletableFuture.runAsync(buildAll);

  }

  private void findObFiles(File root) {
      for (File file : root.listFiles()) {
          if (file.isDirectory()) {
              findObFiles(file);
          } else if (file.getName().endsWith(".ob")) {
            buildFiles.add(file.toURI());
          } 
      }
  }

  private void doBuild(URI uri) {
    //System.err.println("Building: " + uri.toString());

    if (parserFn == null) {
        throw new IllegalStateException("Build requested when parser has not been loaded");
    }

    String filePath = uri.getPath();
    StringCatter filename = new StringCatter(filePath);

    String contents = "";
    try {
      contents = Files.readString(Path.of(filePath));
    } catch (IOException e) {
      e.printStackTrace();
    }
    
    // Gather error messages from the Oberon0 LSP driver
    // Save decorated modules to provide other language features
    NPair result = PlspDriver.invoke(OriginContext.FFI_CONTEXT, new StringCatter(contents), filename, parserFn);
    DecoratedNode decResult = result.decorate();
    ConsCell messages = decResult.synthesized(silver.core.Init.silver_core_snd__ON__silver_core_Pair);
    Object module = decResult.synthesized(silver.core.Init.silver_core_fst__ON__silver_core_Pair);
    savedModules.put(filePath, module);

    // Report diagnostics
    client.publishDiagnostics(new PublishDiagnosticsParams(uri.toString(), Util.messagesToDiagnostics(messages, uri.toString()), savedVersions.get(uri.toString())));
     
  }
}
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

import org.eclipse.lsp4j.DidChangeConfigurationParams;
import org.eclipse.lsp4j.DidChangeTextDocumentParams;
import org.eclipse.lsp4j.DidChangeWatchedFilesParams;
import org.eclipse.lsp4j.DidCloseTextDocumentParams;
import org.eclipse.lsp4j.DidOpenTextDocumentParams;
import org.eclipse.lsp4j.DidSaveTextDocumentParams;
import org.eclipse.lsp4j.PublishDiagnosticsParams;
import org.eclipse.lsp4j.SemanticTokens;
import org.eclipse.lsp4j.SemanticTokensParams;
import org.eclipse.lsp4j.WorkspaceFolder;
import org.eclipse.lsp4j.jsonrpc.CompletableFutures;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;

import common.ConsCell;
import common.OriginContext;
import common.SilverCopperParser;
import common.StringCatter;
import edu.umn.cs.melt.lsp4jutil.CopperParserNodeFactory;
import edu.umn.cs.melt.lsp4jutil.CopperSemanticTokenEncoder;
import edu.umn.cs.melt.lsp4jutil.Util;
import edu.umn.cs.melt.Oberon0.core.concreteSyntax.NModule_c;
import edu.umn.cs.melt.Oberon0.core.driver.PlspDriver;

public class Oberon0LanguageService implements TextDocumentService, WorkspaceService {

  private LanguageClient client;
  private List<WorkspaceFolder> folders;
  private Map<String, String> fileContents = new HashMap<>();
  private Map<String, Integer> fileVersions = new HashMap<>();
  private Set<File> buildFiles = new HashSet<>();
  private Map<String, Integer> savedVersions = new HashMap<>();

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
      String uri = params.getTextDocument().getUri();
      fileContents.put(uri, params.getTextDocument().getText());
      fileVersions.put(uri, params.getTextDocument().getVersion());
      savedVersions.put(uri, params.getTextDocument().getVersion());
      //triggerBuild(false);
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

  @Override
  public void didChangeConfiguration(DidChangeConfigurationParams params) {

  }

  @Override
  public void didChangeWatchedFiles(DidChangeWatchedFilesParams params) {

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
        for (File file : buildFiles) {
          doBuild(file);
        } 
      };

      CompletableFuture.runAsync(buildAll);

  }

  private void findObFiles(File root) {
      for (File file : root.listFiles()) {
          if (file.isDirectory()) {
              findObFiles(file);
          } else if (file.getName().endsWith(".ob")) {
            buildFiles.add(file);
          } 
      }
  }

  private void doBuild(File file) {
    String uri = file.toURI().toString();
    System.err.println("Building: " + uri);
    if (parserFn == null) {
        throw new IllegalStateException("Build requested when parser has not been loaded");
    }

    String filePath = file.getAbsolutePath();
    StringCatter filename = new StringCatter(filePath);

    String contents;
    try {
      contents = Files.readString(Path.of(filePath));
      ConsCell messages = PlspDriver.invoke(OriginContext.FFI_CONTEXT, new StringCatter(contents), filename, parserFn);
      client.publishDiagnostics(new PublishDiagnosticsParams(uri, Util.messagesToDiagnostics(messages, uri)));
    } catch (IOException e) {
      // TODO: Auto-generated catch block
      e.printStackTrace();
    }
     
  }
}
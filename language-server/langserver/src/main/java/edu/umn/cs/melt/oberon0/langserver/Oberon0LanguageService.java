package edu.umn.cs.melt.oberon0.langserver;

import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.nio.file.Path;
import java.util.function.Supplier;

import org.eclipse.lsp4j.DidOpenTextDocumentParams;
import org.eclipse.lsp4j.DidChangeConfigurationParams;
import org.eclipse.lsp4j.DidChangeTextDocumentParams;
import org.eclipse.lsp4j.DidChangeWatchedFilesParams;
import org.eclipse.lsp4j.DidCloseTextDocumentParams;
import org.eclipse.lsp4j.DidSaveTextDocumentParams;
import org.eclipse.lsp4j.SemanticTokens;
import org.eclipse.lsp4j.SemanticTokensParams;
import org.eclipse.lsp4j.WorkspaceFolder;
import org.eclipse.lsp4j.jsonrpc.CompletableFutures;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.lsp4j.services.TextDocumentService;
import org.eclipse.lsp4j.services.WorkspaceService;

import common.DecoratedNode;
import common.SilverCopperParser;
import edu.umn.cs.melt.lsp4jutil.CopperParserNodeFactory;
import edu.umn.cs.melt.lsp4jutil.CopperSemanticTokenEncoder;
import edu.umn.cs.melt.Oberon0.core.concreteSyntax.NModule_c;

public class Oberon0LanguageService implements TextDocumentService, WorkspaceService {

  private LanguageClient client;
  private List<WorkspaceFolder> folders;
  private Map<String, String> fileContents = new HashMap<>();
  private Map<String, Integer> fileVersions = new HashMap<>();
  private Map<String, Integer> savedVersions = new HashMap<>();
  private String generated;

  private String oberon0Grammars = null;

  public Oberon0LanguageService() {
      try {
          generated = Files.createTempDirectory("generated").toString() + "/";
      } catch (IOException e) {
          e.printStackTrace();
      }
  }

  public void setClient(LanguageClient client) {
    this.client = client;
  }

  public void setOberon0GrammarsPath(Path path) {
    this.oberon0Grammars = path.toString() + "/";
  }

  public void setWorkspaceFolders(List<WorkspaceFolder> folders) {
      this.folders = folders;
      //refreshWorkspace();
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

}
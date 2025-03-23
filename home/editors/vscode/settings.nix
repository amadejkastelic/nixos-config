{pkgs, ...}: let
  editor = {
    "editor.fontFamily" = "JetBrains Mono Nerd Font";
    "editor.fontSize" = 18;
    "editor.fontWeight" = "500";
    "editor.fontLigatures" = true;
    "editor.semanticHighlighting.enabled" = true;
    "editor.guides.bracketPairs" = true;
    "editor.guides.indentation" = true;
    "editor.inlineSuggest.enabled" = true;
    "editor.smoothScrolling" = true;
    "editor.tabCompletion" = "on";
    "editor.trimAutoWhitespace" = true;
  };

  explorer = {
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
  };

  extensions = {
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = false;
    "extensions.ignoreRecommendations" = true;
    "update.mode" = "none";
  };

  files = {
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
    "files.autoSave" = "afterDelay";
    "files.exclude" = {
      "**/__pycache__/**" = true;
    };
  };

  telemetry = {
    "telemetry.telemetryLevel" = "off";
  };

  terminal = {
    "terminal.integrated.smoothScrolling" = false;
    "terminal.integrated.fontFamily" = "JetBrains Mono Nerd Font";
    "terminal.integrated.fontSize" = 14;
    "terminal.integrated.minimumContrastRatio" = 1;
  };

  window = {
    "window.zoomLevel" = 1;
    "window.titleBarStyle" = "native";
    "window.customTitleBarVisibility" = "never";
    "window.menuBarVisibility" = "toggle";
    "window.dialogStyle" = "native";
  };

  workbench = {
    "workbench.colorTheme" = "Catppuccin Mocha";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.productIconTheme" = "material-produc  t-icons";
    "workbench.startupEditor" = "none";
    "workbench.editor.tabActionCloseVisibility" = false;
  };

  # Extensions
  catppuccin = {
    "catppuccin.italicComments" = false;
    "catppuccin.italicKeywords" = false;
    "catppuccin.extraBordersEnabled" = false;
    "catppuccin.workbenchMode" = "default";
    "catppuccin.bracketMode" = "rainbow";
    "catppuccin.customUIColors" = {
      "all" = {
        "statusBar.foreground" = "accent";
        "statusBar.noFolderForeground" = "accent";
      };
    };
  };

  formatter = {
    "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
    "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
  };

  nix = {
    "nix.enableLanguageServer" = true;
    "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
    "nix.serverPath" = "${pkgs.nil}/bin/nil";
    "nix.serverSettings"."nil"."formatting"."command" = ["${pkgs.alejandra}/bin/alejandra"];
  };

  python = {
    "python.defaultInterpreterPath" = "${pkgs.python312}/bin/python";
    "python.languageServer" = "Pylance";
    "python.analysis.typeCheckingMode" = "strict";
  };

  continue = {
    "continue.telemetryEnabled" = false;
    "continue.enableTabAutocomplete" = false;
  };

  twinny = {
    "twinny.enabled" = false;
    "twinny.enableLogging" = false;

    "twinny.autoSuggestEnabled" = true;
    "twinny.multilineCompletionsEnabled" = false;
    "twinny.maxLines" = 1;
    "twinny.fileContextEnabled" = false;
    "twinny.completionCacheEnabled" = true;

    "twinny.ollamaHostname" = "0.0.0.0";
    "twinny.ollamaApiPort" = 11434;
  };

  svelte = {
    "svelte.enable-ts-plugin" = true;
  };
in {
  programs.vscode.profiles.default.userSettings =
    {}
    // editor
    // explorer
    // extensions
    // files
    // telemetry
    // terminal
    // window
    // workbench
    // catppuccin
    // formatter
    // nix
    // python
    // continue
    // twinny
    // svelte;
}

{ pkgs, lib, ... }:
let
  editor = {
    "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
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
    "extensions.verifySignature" = false;
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

  search = {
    "search.followSymlinks" = false;
  };

  telemetry = {
    "telemetry.telemetryLevel" = "off";
  };

  terminal = {
    "terminal.integrated.smoothScrolling" = false;
    "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
    "terminal.integrated.fontSize" = 14;
    "terminal.integrated.minimumContrastRatio" = 1;
    "terminal.integrated.stickyScroll.enabled" = false;
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
    "workbench.iconTheme" = lib.mkForce "material-icon-theme";
    "workbench.productIconTheme" = "material-product-icons";
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
    "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
  };

  nix = {
    "nix.enableLanguageServer" = true;
    "nix.formatterPath" = "nixfmt";
    "nix.serverPath" = "${pkgs.nil}/bin/nil";
    "nix.serverSettings"."nil"."formatting"."command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
    "[nix]" = {
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
    };
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

  svelte = {
    "svelte.enable-ts-plugin" = true;
  };

  copilot = {
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = true;
      "scminput" = false;
    };
  };

  claude = {
    "claudeCode.useTerminal" = true;
  };
in
{
  programs.vscode.profiles.default.userSettings =
    { }
    // editor
    // explorer
    // extensions
    // files
    // search
    // telemetry
    // terminal
    // window
    // workbench
    // catppuccin
    // formatter
    // nix
    // python
    // continue
    // svelte
    // copilot
    // claude;
}

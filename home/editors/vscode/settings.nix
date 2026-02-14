{ pkgs, lib, ... }:
let
  editor = {
    "editor.fontSize" = lib.mkForce 18;
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
    "terminal.integrated.fontSize" = lib.mkForce 14;
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
    "workbench.colorTheme" = lib.mkForce "Catppuccin Mocha";
    "workbench.iconTheme" = lib.mkForce "material-icon-theme";
    "workbench.productIconTheme" = "material-product-icons";
    "workbench.startupEditor" = "none";
    "workbench.editor.tabActionCloseVisibility" = false;
  };

  update = {
    "update.showReleaseNotes" = false;
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
    "nix.serverPath" = lib.getExe pkgs.nixd;
    "nix.serverSettings"."nixd"."formatting"."command" = [ "${lib.getExe pkgs.nixfmt}" ];
    "[nix]" = {
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
    };
  };

  python = {
    "python.defaultInterpreterPath" = lib.getExe pkgs.python3;
    "python.languageServer" = "Pylance";
    "python.analysis.typeCheckingMode" = "strict";
  };

  zig = {
    "zig.path" = "zig";
    "zig.zls.enabled" = "on";
    "zig.zls.path" = "zls";
  };

  continue = {
    "continue.telemetryEnabled" = false;
    "continue.enableTabAutocomplete" = true;
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
    "chat.disableAIFeatures" = true;
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
    // update
    // catppuccin
    // formatter
    // nix
    // python
    // zig
    // continue
    // svelte
    // copilot;
}

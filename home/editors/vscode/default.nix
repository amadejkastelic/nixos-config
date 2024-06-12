{
  pkgs,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      # Theme
      catppuccin.catppuccin-vsc
      pkief.material-product-icons

      # Nix
      kamadorueda.alejandra
      jnoortheen.nix-ide
      arrterian.nix-env-selector

      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.black-formatter
      charliermarsh.ruff
    ];

    userSettings = {
      # Editor
      "editor.fontFamily" = "JetBrains Mono Nerd Font";
      "editor.fontSize" = 18;
      "editor.fontLigatures" = true;
      "editor.semanticHighlighting.enabled" = true;

      # Window
      "window.zoomLevel" = 1;
      "window.titleBarStyle" = "custom";

      # Files
      "files.autoSave" = "afterDelay";

      # Terminal
      "terminal.integrated.fontFamily" = "JetBrains Mono Nerd Font";
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.minimumContrastRatio" = 1;

      # gopls
      "gopls.ui.semanticTokens" = true;

      # Theme
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "catppuccin.accentColor" = "pink";
      "catppuccin.customUIColors.mocha.statusBar.foreground" = "accent";
    };

    keybindings = [
      {
        key = "ctrl+shift+o";
        command = "workbench.action.quickOpen";
      }
      {
        key = "ctrl+d";
        command = "editor.action.copyLinesDownAction";
      }
    ];
  };
}

{pkgs, ...}: {
  programs.vscode = {
    mutableExtensionsDir = true;
    extensions =
      (with pkgs.vscode-marketplace; [
        # Icons
        pkief.material-product-icons
        pkief.material-icon-theme

        # Nix
        kamadorueda.alejandra
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # Python
        ms-python.flake8
        ms-python.vscode-pylance
        ms-python.black-formatter

        # TOML
        tamasfe.even-better-toml

        # AI
        ex3ndr.llama-coder

        # Docker
        ms-azuretools.vscode-docker
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.python
        ms-python.debugpy
        # Rust
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
      ])
      ++ [
        # Theme
        (pkgs.catppuccin-vsc.override {
          accent = "pink";
          italicComments = false;
          italicKeywords = false;
          extraBordersEnabled = false;
          workbenchMode = "default";
          bracketMode = "rainbow";
          customUIColors = {
            all = {
              "statusBar.foreground" = "accent";
              "statusBar.noFolderForeground" = "accent";
            };
          };
        })
      ];
  };
}

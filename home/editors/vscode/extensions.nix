{pkgs, ...}: {
  programs.vscode = {
    mutableExtensionsDir = false;
    profiles.default.extensions =
      (with pkgs.vscode-marketplace; [
        # Icons
        pkief.material-product-icons
        pkief.material-icon-theme

        # Nix
        kamadorueda.alejandra
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # Rust
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer

        # Python
        ms-python.flake8
        ms-python.vscode-pylance
        ms-python.black-formatter

        # Flutter
        dart-code.flutter

        # TOML
        tamasfe.even-better-toml

        # Docker
        ms-azuretools.vscode-docker

        # Svelte
        svelte.svelte-vscode

        # AI
        rjmacarthy.twinny
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.python
        ms-python.debugpy
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

  home.file.".continue/config.json".text = builtins.toJSON {
    models = [
      {
        title = "Deepseek-R1";
        provider = "ollama";
        model = "deepseek-r1:14b";
      }
    ];
    tabAutocompleteModel = {
      title = "Supernova-Medius";
      provider = "ollama";
      model = "vanilj/supernova-medius:iq2_m";
    };
  };
}

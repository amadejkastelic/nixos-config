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
        ms-python.python
        ms-python.flake8
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
        github.copilot
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.debugpy
        ms-python.vscode-pylance

        # AI
        # continue.continue
      ]);
  };

  catppuccin.vscode = {
    enable = true;
    accent = "pink";
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

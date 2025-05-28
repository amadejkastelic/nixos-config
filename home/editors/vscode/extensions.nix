{ pkgs, ... }:
{
  programs.vscode = {
    mutableExtensionsDir = false;
    profiles.default.extensions =
      (with pkgs.vscode-marketplace; [
        # Icons
        pkief.material-product-icons
        pkief.material-icon-theme

        # Nix
        jnoortheen.nix-ide
        mkhl.direnv

        # Rust
        rust-lang.rust-analyzer

        # Python
        ms-python.python
        ms-python.flake8
        ms-python.black-formatter

        # TOML
        tamasfe.even-better-toml

        # Docker
        ms-azuretools.vscode-docker

        # Svelte
        svelte.svelte-vscode

        # go
        golang.go

        # AI
        github.copilot
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.debugpy
        ms-python.vscode-pylance

        # Rust
        vadimcn.vscode-lldb

        # Typst
        myriad-dreamin.tinymist

        # PDF preview
        tomoki1207.pdf

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

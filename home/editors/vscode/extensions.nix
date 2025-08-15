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
        charliermarsh.ruff

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
        anthropic.claude-code
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.debugpy
        ms-python.vscode-pylance

        # Rust
        vadimcn.vscode-lldb

        # Typst
        myriad-dreamin.tinymist

        # Git Blame
        eamodio.gitlens

        # AI
        # continue.continue
      ]);
  };

  catppuccin.vscode.profiles.default = {
    enable = true;
    accent = "pink";
  };

  home.file.".continue/config.json".text = builtins.toJSON {
    models = [
      {
        title = "gpt-oss";
        provider = "ollama";
        model = "gpt-oss:20b";
      }
    ];
    tabAutocompleteModel = {
      title = "Supernova-Medius";
      provider = "ollama";
      model = "vanilj/supernova-medius:iq2_m";
    };
  };
}

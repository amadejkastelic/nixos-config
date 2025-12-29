{
  config,
  pkgs,
  ...
}:
{
  programs.vscode = {
    mutableExtensionsDir = false;
    profiles.default.extensions =
      (with pkgs.vscode-marketplace; [
        # Icons
        pkief.material-product-icons
        pkief.material-icon-theme

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
        # github.copilot
        anthropic.claude-code
        sst-dev.opencode
      ])
      ++ (with pkgs.vscode-extensions; [
        # Python
        ms-python.debugpy
        ms-python.vscode-pylance

        # Nix
        jnoortheen.nix-ide
        mkhl.direnv

        # Rust
        vadimcn.vscode-lldb

        # Typst
        myriad-dreamin.tinymist

        # Git Blame
        eamodio.gitlens

        # AI
        continue.continue
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

  sops.templates."continue-config.json" = {
    content = builtins.toJSON {
      models = [
        {
          title = "GLM-4.7";
          provider = "openai";
          model = "GLM-4.7";
          apiKey = config.sops.placeholder.z-ai-api-token;
          apiBase = "https://api.z.ai/api/coding/paas/v4";
        }
      ];
      tabAutocompleteModel = {
        title = "GLM-4.7";
        provider = "openai";
        model = "GLM-4.7";
        apiKey = config.sops.placeholder.z-ai-api-token;
        apiBase = "https://api.z.ai/api/coding/paas/v4";
        useLegacyCompletionsEndpoint = false;
      };
    };
    mode = "0400";
    path = "${config.home.homeDirectory}/.continue/config.json";
  };

  home.file.".continue/config.json".force = true;

  sops.secrets.z-ai-api-token = { };
}

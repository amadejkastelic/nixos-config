{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.nushell = {
    enable = true;

    plugins = with pkgs.nushellPlugins; [
      desktop_notifications
      gstat
      highlight
      skim
    ];

    shellAliases = {
      grep = "grep --color";
      ip = "ip --color";
      ll = "eza -la";
      us = "systemctl --user";
      rs = "sudo systemctl";
    }
    // lib.optionalAttrs (config.programs.bat.enable == true) { cat = "bat"; };

    # Workaround - https://github.com/nix-community/home-manager/issues/4313
    environmentVariables = config.home.sessionVariables;

    settings = {
      show_banner = false;
      edit_mode = "vi";

      history = {
        file_format = "sqlite";
        max_size = 1000000;
        sync_on_enter = true;
        isolation = false;
      };

      completions.algorithm = "fuzzy";

      use_ansi_coloring = true;

      display_errors = {
        exit_code = false;
        termination_signal = false;
      };
    };

    extraConfig = ''
      if ($nu.is-interactive and ($env | get -o TERM) != null) {
        ${lib.getExe inputs.nanofetch.packages.${pkgs.stdenv.hostPlatform.system}.nanofetch}
      }
    '';

    extraEnv = ''
      let cb_path = "${config.sops.secrets.codeberg-token.path}"
      if ($cb_path | path exists) {
        $env.CODEBERG_TOKEN = (open $cb_path | str trim)
      }

      let gh_path = "${config.sops.secrets.github-token.path}"
      if ($gh_path | path exists) {
        $env.GITHUB_TOKEN = (open $gh_path | str trim)
      }

      let zai_path = "${config.sops.secrets.z-ai-api-token.path}"
      if ($zai_path | path exists) {
        $env.Z_AI_API_KEY = (open $zai_path | str trim)
      }
    '';
  };

  catppuccin.nushell.enable = true;

  sops.secrets = {
    codeberg-token = { };
    github-token = { };
    z-ai-api-token = { };
  };
}

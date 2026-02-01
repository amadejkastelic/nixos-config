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
      ${lib.getExe inputs.nanofetch.packages.${pkgs.stdenv.hostPlatform.system}.nanofetch}
    '';
  };
}

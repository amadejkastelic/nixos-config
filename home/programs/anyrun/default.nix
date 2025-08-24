{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  preprocessScript = pkgs.writeShellScriptBin "anyrun-preprocess-application-exec" ''
    shift
    echo "uwsm app -- $*"
  '';
in
{
  programs.anyrun = {
    enable = true;

    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.shell
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
    };

    extraCss = builtins.readFile (./. + "/style-${config.theme.name}.css");

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 5,
          terminal: Some("ghostty"),
          preprocess_exec_script: Some("${lib.getExe preprocessScript}"),
        )
      '';

      "shell.ron".text = ''
        Config(
          prefix: ">"
        )
      '';
    };
  };
}

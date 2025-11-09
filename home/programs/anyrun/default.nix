{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  anyrunPkgs = inputs.anyrun.packages.${pkgs.stdenv.hostPlatform.system};

  preprocessScript = pkgs.writeShellScriptBin "anyrun-preprocess-application-exec" ''
    shift
    echo "uwsm app -- $*"
  '';
in
{
  imports = [
    (
      { modulesPath, ... }:
      {
        # Important! We disable home-manager's module to avoid option
        # definition collisions
        disabledModules = [ "${modulesPath}/programs/anyrun.nix" ];
      }
    )
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;

    package = anyrunPkgs.anyrun;

    config = with anyrunPkgs; {
      plugins = [
        applications
        shell
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

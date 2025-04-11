{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.anyrun = {
    enable = true;

    config = {
      plugins = [
        inputs.anyrun-uwsm.packages.${pkgs.system}.uwsm_app
        inputs.anyrun.packages.${pkgs.system}.shell
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = builtins.readFile (./. + "/style-${config.theme.name}.css");

    extraConfigFiles = {
      "uwsm_app.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 5,
          terminal: Some("ghostty"),
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

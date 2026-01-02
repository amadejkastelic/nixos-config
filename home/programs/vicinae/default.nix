{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;

    systemd = {
      enable = true;

      environment = {
        USE_LAYER_SHELL = 1;
        QT_SCALE_FACTOR = 1;
      };
    };

    settings = {
      launcher_window.opacity = 0.5;

      theme = {
        light = {
          name = "catppuccin-latte";
          icon_theme = config.stylix.iconTheme.light;
        };
        dark = {
          name = "catppuccin-mocha";
          icon_theme = config.stylix.iconTheme.dark;
        };
      };

      providers = {
        "applications" = {
          preferences = {
            launchPrefix = "uwsm app -- ";
          };
        };
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      nix
      wifi-commander
    ];
  };
}

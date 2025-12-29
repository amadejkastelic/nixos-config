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
      close_on_focus_loss = true;

      launcher_window.opacity = 0.5;

      theme = {
        light = {
          name = "catppuccin-latte";
          icon_theme = "Papirus-Dark";
        };
        dark = {
          name = "catppuccin-${config.catppuccin.flavor}";
          icon_theme = "Papirus-Dark";
        };
      };

      font.normal = {
        size = 11;
        normal = "JetBrainsMono Nerd Font Mono";
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

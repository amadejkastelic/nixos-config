{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    systemd.enable = true;

    settings = {
      close_on_focus_loss = true;

      launcher_window.opacity = 0.5;

      theme = {
        light = {
          name = "catppuccin-latte";
          icon_theme = "Catppuccin Latte ${lib.toSentenceCase config.catppuccin.accent}";
        };
        dark = {
          name = "catppuccin-${config.catppuccin.flavor}";
          icon_theme = "Catppuccin ${lib.toSentenceCase config.catppuccin.flavor} ${lib.toSentenceCase config.catppuccin.accent}";
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

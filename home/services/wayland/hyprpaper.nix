{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      wallpaper = lib.mkForce {
        monitor = "DP-2";
        path = toString config.stylix.image;
        fit_mode = "cover";
      };
      splash = false;
    };
  };
}

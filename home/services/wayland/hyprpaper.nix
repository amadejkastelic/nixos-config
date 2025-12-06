{
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
      wallpaper = {
        monitor = "DP-2";
        path = toString config.theme.wallpaper;
        fit_mode = "cover";
      };
      splash = false;
    };
  };
}

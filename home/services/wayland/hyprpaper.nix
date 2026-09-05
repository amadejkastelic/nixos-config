{ config, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      preload = toString config.stylix.image;
      wallpaper = {
        monitor = "";
        path = toString config.stylix.image;
        fit_mode = "cover";
      };
      splash = false;
    };
  };
}

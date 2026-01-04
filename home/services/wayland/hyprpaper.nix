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
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${toString config.stylix.image}

    wallpaper {
      monitor =
      path = ${toString config.stylix.image}
      fit_mode = cover
    }

    splash = false
  '';
}

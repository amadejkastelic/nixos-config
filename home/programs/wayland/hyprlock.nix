{
  inputs,
  pkgs,
  config,
  ...
}:
{
  catppuccin.hyprlock.enable = true;

  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;

    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = toString config.stylix.image;

          blur_size = 4;
          blur_passes = 3;
          noise = 0.0117;
          contrast = 1.3000;
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];
    };
  };
}

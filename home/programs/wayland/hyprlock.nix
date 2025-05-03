{ config, ... }:
{
  catppuccin.hyprlock.enable = true;
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = "${config.theme.wallpaper}";

          blur_size = 4;
          blur_passes = 3;
          noise = 0.0117;
          contrast = 1.3000;
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.2;
          dots_spacing = 0.64;
          dots_center = true;
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
      ];

      # Current time
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
          font_size = 64;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, 75";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''Hey <span text_transform="capitalize" size="larger">$USER</span>'';
          font_size = 20;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Type to unlock!";
          font_size = 16;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, 10";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}

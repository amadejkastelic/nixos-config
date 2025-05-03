{ inputs, ... }:
{
  imports = [
    inputs.hyprlux.homeManagerModules.default
  ];

  programs.hyprlux = {
    enable = true;

    systemd = {
      enable = false;
      target = "graphical-session.target";
    };

    night_light = {
      enabled = true;
      latitude = 46.056946;
      longitude = 14.505751;
      temperature = 3500;
    };

    vibrance_configs = [
      {
        window_class = "steam_app_1172470";
        window_title = "Apex Legends";
        strength = 105;
      }
      {
        window_class = "cs2";
        window_title = "Counter-Strike 2";
        strength = 100;
      }
    ];
  };
}

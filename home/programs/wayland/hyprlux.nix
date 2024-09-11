{inputs, ...}: {
  imports = [
    inputs.hyprlux.homeManagerModules.default
  ];

  programs.hyprlux = {
    enable = true;

    night_light = {
      enabled = true;
      start_time = "20:00";
      end_time = "06:00";
      temperature = 3500;
    };

    vibrance_configs = [
      {
        window_class = "steam_app_1172470";
        window_title = "Apex Legends";
        strength = 100;
      }
      {
        window_class = "cs2";
        window_title = "";
        strength = 100;
      }
    ];
  };
}

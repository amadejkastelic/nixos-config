{
  lib,
  config,
  ...
}: {
  services.hypridle = {
    enable = true;

    settings = {
      lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
      listener = [
        {
          timeout = 300;
          onTimeout = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        }
        {
          timeout = 500;
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

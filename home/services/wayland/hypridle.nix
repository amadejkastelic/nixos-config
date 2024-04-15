{
  pkgs,
  lib,
  config,
  ...
}: {
  # screen idle
  services.hypridle = {
    enable = true;
    lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";

    listeners = [
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
}

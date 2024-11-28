{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;

    package = inputs.hypridle.packages.${pkgs.system}.hypridle;

    settings = {
      general = {
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };

      listener = [
        {
          timeout = 500;
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  services.hypridle = {
    enable = true;

    package = inputs.hypridle.packages.${pkgs.system}.hypridle;

    settings = {
      general = {
        lock_cmd = "pgrep hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 500;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

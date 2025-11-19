{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (pkgs.writers) writeDash;

  hyprctl = "${lib.getExe' config.programs.hyprland.package "hyprctl"} -i 0";
  powerprofilesctl = lib.getExe pkgs.power-profiles-daemon;
  notify-send = lib.getExe pkgs.libnotify;

  resolutionScript = pkgs.writeShellScriptBin "resolution" ''
    refresh_rate=''${3:-120}
    ${hyprctl} keyword monitor "DP-2,$1x$2@''${refresh_rate},0x0,1"
  '';

  startScript = writeDash "gamemode-start" ''
    ${hyprctl} --batch "\
      keyword animations:enabled 0;\
      keyword decoration:shadow:enabled 0;\
      keyword decoration:blur:enabled 0;\
      keyword general:gaps_in 0;\
      keyword general:gaps_out 0;\
      keyword general:border_size 1;\
      keyword plugin:dynamic-cursors:enabled 0;\
      keyword decoration:rounding 0"
    ${powerprofilesctl} set performance
    ${notify-send} -u low -a 'Gamemode' 'Optimizations activated'
  '';
  endScript = writeDash "gamemode-end" ''
    ${hyprctl} reload
    ${powerprofilesctl} set balanced
    ${notify-send} -u low -a 'Gamemode' 'Optimizations deactivated'
  '';
in
{
  environment.systemPackages = [ resolutionScript ];

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };

      custom = {
        start = startScript.outPath;
        end = endScript.outPath;
      };
    };
  };
}

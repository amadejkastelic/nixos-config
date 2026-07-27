{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.writers) writeDash;

  hyprctl = "${lib.getExe' config.programs.hyprland.package "hyprctl"} -i 0";
  powerprofilesctl = lib.getExe pkgs.power-profiles-daemon;
  notify-send = lib.getExe pkgs.libnotify;

  gaming = config.workstation.gaming;
  display = lib.findFirst (
    candidate: candidate.output == gaming.output
  ) null config.workstation.displays;
  needsResolutionChange =
    gaming.width != display.width
    || gaming.height != display.height
    || gaming.refreshRate != display.refreshRate
    || gaming.scale != display.scale;

  resolutionScript = pkgs.writeShellScriptBin "resolution" ''
    ${lib.optionalString (!needsResolutionChange) "exit 0"}
    refresh_rate=''${3:-${toString gaming.refreshRate}}
    ${hyprctl} eval "hl.monitor({ output = \"${gaming.output}\", mode = \"$1x$2@''${refresh_rate}\", position = \"${display.position}\", scale = ${builtins.toJSON gaming.scale} })"
  '';

  startScript = writeDash "gamemode-start" ''
    ${lib.getExe resolutionScript} ${toString gaming.width} ${toString gaming.height} ${toString gaming.refreshRate}
    ${hyprctl} hyprsunset identity
    ${hyprctl} eval "hl.config({
      animations = { enabled = false },
      decoration = {
        shadow = { enabled = false },
        blur = { enabled = false },
        rounding = 0,
      },
      general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
      },
    })"
    ${powerprofilesctl} set performance
    ${notify-send} -u low -a 'Gamemode' 'Optimizations activated'
  '';
  endScript = writeDash "gamemode-end" ''
    ${hyprctl} hyprsunset reset
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

{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  hyprctl =
    lib.getExe' inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      "hyprctl";
  jq = lib.getExe pkgs.jq;

  saveWindows = pkgs.writeShellScriptBin "hyprland-save-windows" ''
    STATE_DIR="/tmp/hyprland-window-state"
    mkdir -p "$STATE_DIR"

    STATE_FILE="$STATE_DIR/floating-windows.json"

    # Get all floating windows
    ${hyprctl} clients -j | ${jq} -r '[.[] | select(.floating == true and .mapped == true) | {
      pid: .pid,
      monitor: .monitor,
      at: .at,
      fullscreen: .fullscreen
    }]' > "$STATE_FILE"

    echo "Saved floating window positions to $STATE_FILE"
    ${jq} '.' "$STATE_FILE"
  '';

  restoreWindows = pkgs.writeShellScriptBin "hyprland-restore-windows" ''
    STATE_DIR="/tmp/hyprland-window-state"
    STATE_FILE="$STATE_DIR/floating-windows.json"

    if [ ! -f "$STATE_FILE" ]; then
      echo "No window state file found"
      exit 1
    fi

    echo "Waiting for displays to reconnect..."

    # Wait for monitors to be available
    for i in $(seq 1 40); do
      MON_COUNT=$(${hyprctl} monitors -j | ${jq} -e 'length')
      if [ "$MON_COUNT" -gt 0 ]; then
        echo "Displays available"
        break
      fi
      sleep 0.5
    done

    echo "Restoring window positions from $STATE_FILE"

    # Read the saved state and restore each window
    ${jq} -c '.[]' "$STATE_FILE" | while read -r window; do
      pid=$(${jq} -r '.pid' <<< "$window")
      x=$(${jq} -r '.at[0]' <<< "$window")
      y=$(${jq} -r '.at[1]' <<< "$window")
      fullscreen=$(${jq} -r '.fullscreen' <<< "$window")

      echo "Restoring window with pid $pid to position $x,$y"

      # Move window to original position using pid selector
      ${hyprctl} dispatch movewindowpixel "exact $x $y,pid:$pid"

      # Restore fullscreen state if needed
      if [ "$fullscreen" = "1" ]; then
        echo "Restoring fullscreen for window with pid $pid"
        ${hyprctl} dispatch togglefullscreen "pid:$pid"
      fi
    done

    # Restart Quickshell
    echo "Restarting Quickshell"
    systemctl --user restart quickshell.service

    echo "Window restoration complete"
  '';
in
{
  services.hypridle = {
    enable = true;

    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;

    settings = {
      general = {
        lock_cmd = "pgrep hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        before_sleep_cmd = "${lib.getExe saveWindows} && ${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on && ${lib.getExe restoreWindows}";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 300;
          on-timeout = "${lib.getExe saveWindows} && hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && ${lib.getExe restoreWindows}";
        }
        {
          timeout = 360;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

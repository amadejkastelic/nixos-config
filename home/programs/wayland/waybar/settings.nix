{
  pkgs,
  lib,
  ...
}:
{
  # https://www.nerdfonts.com/cheat-sheet

  home.packages = [ pkgs.radeontop ];

  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "bottom";
    height = 31;
    width = 1920;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "tray"
      "cpu"
      "memory"
      "disk"
      "custom/gpu-usage"
      "pulseaudio"
      "custom/blue-light-filter"
      "network"
    ];
    clock = {
      format = " {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        /*
            "1" = "󰈹";
          "2" = "";
          "3" = "󰘙";
          "4" = "";
          "5" = "";
          "6" = "";
          urgent = "";
          default = "";
        */
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
      };
    };
    memory = {
      format = "󰟜 {}%";
      format-alt = "󰟜 {used} GiB"; # 
      interval = 2;
    };
    cpu = {
      format = "  {usage}%";
      format-alt = "  {avg_frequency} GHz";
      interval = 2;
    };
    disk = {
      # path = "/";
      format = "󰋊 {percentage_used}%";
      interval = 60;
    };
    network = {
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰀂 ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
      on-click = "nm-connection-editor";
    };
    tray = {
      icon-size = 20;
      spacing = 5;
      rotate = 0;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁 ";
      format-icons = {
        default = [ " " ];
      };
      scroll-step = 5;
      on-click = "pavucontrol -t 3";
    };
    "custom/launcher" = {
      format = "";
      on-click = "pkill anyrun || anyrun";
      tooltip = "false";
    };
    "custom/blue-light-filter" = {
      format = "{icon}";
      format-icons = [
        "󱠃"
        "󱠂"
      ];
      on-click = "hyprctl hyprsunset temperature 3000";
      on-click-right = "hyprctl hyprsunset identity";
      tooltip = false;
    };
    "custom/gpu-usage" = {
      exec = "${lib.getExe pkgs.radeontop} -d - -l 1 | tr -d '\n' | cut -s -d ',' -f3 | cut -s -d ' ' -f3 | tr -d '%' | awk '{ print int($1) }' | tr -d '\n'";
      format = "󰢮 {}%";
      interval = 2;
      format-tooltip = "GPU Usage";
    };
  };
}

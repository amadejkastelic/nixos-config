{ ... }:
let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = "#cdd6f4";
    secondary_accent = "#f5c2e7";
    tertiary_accent = "#f5f5f5";
    background = "#1e1e2e";
    opacity = "0.98";
    crust = "#11111b";
  };
in
{
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 16px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        background-color: alpha(${custom.background}, 0.999);
        border: 2px solid alpha(${custom.crust}, 0.3);
        margin: 10px 10px;
    }

    #workspaces {
        font-size: 18px;
        padding-left: 15px;
    }

    #workspaces button {
        color: ${custom.text_color};
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button.empty {
        color: #6c7086;
    }
    #workspaces button.active {
        color: #b4befe;
    }

    #tray, #pulseaudio, #network, #cpu, #memory, #disk, #custom-gpu-usage, #clock, #custom-blue-light-filter {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #cpu {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #memory {
        padding-left: 9px;
        padding-right: 9px;
    }
    #disk {
        padding-left: 9px;
        padding-right: 9px;
    }
    #custom-gpu-usage {
        padding-left: 9px;
        padding-right: 15px;
    }


    #tray {
        padding: 0 20px;
        margin-left: 7px;
    }

    #pulseaudio {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #network {
        padding-left: 9px;
        padding-right: 15px;
    }

    #clock {
        padding-left: 9px;
        padding-right: 15px;
    }

    #custom-launcher {
        font-size: 20px;
        color: #b4befe;
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 15px;
    }
    #custom-blue-light-filter {
        padding-left: 9px;
        padding-right: 15px;
    }
  '';
}

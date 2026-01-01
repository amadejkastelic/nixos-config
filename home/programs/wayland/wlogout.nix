{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  bgImageSection = name: ''
    #${name} {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
    }
  '';
  hyprlock = lib.getExe inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
in
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "${hyprlock}";
        text = "Lock";
      }
      {
        label = "suspend";
        action = "${config.services.hypridle.settings.general.before_sleep_cmd} && systemctl suspend";
        text = "Suspend";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
      }
    ];
  };

  catppuccin.wlogout = {
    enable = true;

    flavor = "mocha";
    accent = "pink";

    extraStyle = ''
      * {
        background: none;
      }

      window {
      	background-color: rgba(0, 0, 0, .6);
      }

      button {
        background: rgba(0, 0, 0, .05);
        border-radius: 8px;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 rgba(0, 0, 0, .5);
        margin: 1rem;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 10%;
      }

      button:focus, button:active, button:hover {
        background-color: rgba(255, 255, 255, 0.2);
        outline-style: none;
      }

      ${lib.concatMapStringsSep "\n" bgImageSection [
        "lock"
        "suspend"
        "shutdown"
        "reboot"
      ]}
    '';
  };
}

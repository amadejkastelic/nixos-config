{
  pkgs,
  lib,
  ...
}: let
  bgImageSection = name: ''
    #${name} {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
    }
  '';
in {
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
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

    style = ''
      * {
        background: none;
        max-width: 500px;
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
        "logout"
        "shutdown"
        "reboot"
      ]}
    '';
  };
}

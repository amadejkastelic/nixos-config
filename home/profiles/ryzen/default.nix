{ inputs, ... }:
let
  vscode-server = "${inputs.vscode-server}/modules/vscode-server/home.nix";
in
{
  imports = [
    # editors
    ../../editors/neovim
    ../../editors/vscode

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    ../../services/networkmanager
    ../../services/gpg

    # media services
    ../../services/media/playerctl.nix
    ../../services/media/easyeffects.nix

    # system services
    ../../services/system/polkit-agent.nix
    ../../services/system/cliphist.nix
    ../../services/system/tailray.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    ../../services/wayland/hyprsunset.nix
    # ../../services/wayland/mako.nix

    # terminal emulators
    ../../terminal/emulators/kitty.nix
    ../../terminal/emulators/ghostty.nix

    # catppuccin
    inputs.catppuccin.homeModules.catppuccin

    # Vesktop
    inputs.nixcord.homeModules.nixcord

    vscode-server
  ];
}

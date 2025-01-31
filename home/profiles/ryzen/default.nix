{inputs, ...}
: {
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

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    ../../services/wayland/mako.nix

    # terminal emulators
    ../../terminal/emulators/kitty.nix
    ../../terminal/emulators/ghostty.nix

    # catppuccin
    inputs.catppuccin.homeManagerModules.catppuccin

    # Vesktop
    inputs.nixcord.homeManagerModules.nixcord
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-2,5120x1440@120,0x0,1.25"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
  '';
}

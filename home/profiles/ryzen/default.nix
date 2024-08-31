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

    # catppuccin
    inputs.catppuccin.homeManagerModules.catppuccin

    # Vesktop
    inputs.nixcord.homeManagerModules.nixcord
  ];

  wayland.windowManager.hyprland.settings = let
    accelpoints = "0.21 0.000 0.040 0.080 0.140 0.200 0.261 0.326 0.418 0.509 0.601 0.692 0.784 0.875 0.966 1.058 1.149 1.241 1.332 1.424 1.613";
  in {
    monitor = [
      "DP-2,5120x1440@120,0x0,1.25"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
  '';

  #catppuccin.flavour = "mocha";
}

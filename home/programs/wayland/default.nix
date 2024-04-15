{
  pkgs,
  self,
  ...
}:
# Wayland config
{
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./hyprshade.nix
    ./wlogout.nix
    ./waybar
    ./rofi.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    # grimblast --freeze needs this
    hyprpicker

    # utils
    self.packages.${pkgs.system}.wl-ocr
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    # SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}

{
  pkgs,
  self,
  inputs,
  ...
}:
# Wayland config
{
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./hyprlux.nix
    ./hyprshade.nix
    ./wlogout.nix
    ./waybar
    ./rofi.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    inputs.hyprsysteminfo.packages.${pkgs.system}.default

    # utils
    self.packages.${pkgs.system}.wl-ocr
    wl-clipboard
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}

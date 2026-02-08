{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pulsemixer

    # images
    loupe
    krita

    # Apple Music
    cider-2
  ];
}

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
    gimp

    # music
    cider-2
    audacious
  ];
}

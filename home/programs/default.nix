{ pkgs, ... }:
{
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/schizofox.nix
    ./media
    ./nix.nix
    ./gtk.nix
    ./qt.nix
    ./office
    ./social
  ];

  home.packages = with pkgs; [
    mission-center
    wineWowPackages.wayland
    ledger-live-desktop
    pinentry-gnome3
    gnumake
    hoppscotch
    qbittorrent-enhanced
    telegram-desktop
  ];
}

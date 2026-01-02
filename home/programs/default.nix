{ pkgs, ... }:
{
  imports = [
    ./browsers/chromium.nix
    ./browsers/schizofox.nix
    ./browsers/zen.nix
    ./media
    ./nix.nix
    ./gtk.nix
    ./qt.nix
    ./office
    ./social
    ./vicinae
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

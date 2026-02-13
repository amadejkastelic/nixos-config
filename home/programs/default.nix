{ pkgs, ... }:
{
  imports = [
    ./browsers/chromium.nix
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
    wineWow64Packages.wayland
    ledger-live-desktop
    pinentry-gnome3
    gnumake
    hoppscotch
    qbittorrent-enhanced
    telegram-desktop
    gnome-disk-utility
  ];
}

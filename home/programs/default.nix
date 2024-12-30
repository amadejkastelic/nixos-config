{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/schizofox.nix
    ./social/discord.nix
    ./media
    ./gtk.nix
    ./qt.nix
    ./office
  ];

  home.packages = with pkgs; [
    mission-center
    wineWowPackages.wayland
    ledger-live-desktop
    pinentry-gnome3
    gnumake
    hoppscotch
    qbittorrent-enhanced
    oversteer
    telegram-desktop
  ];
}

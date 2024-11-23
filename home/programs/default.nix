{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/schizofox.nix
    ./browsers/zen.nix
    ./social/discord.nix
    ./media
    ./gtk.nix
    ./qt.nix
    ./office
  ];

  home.packages = with pkgs; [
    # mission-center
    wineWowPackages.wayland
    ledger-live-desktop
    pinentry-gnome3
    gnumake
    hoppscotch
    qbittorrent-enhanced
    oversteer
  ];
}

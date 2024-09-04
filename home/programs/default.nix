{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/schizofox.nix
    ./social/discord.nix
    ./media
    ./gtk.nix
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
  ];
}

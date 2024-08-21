{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    #./fuzzel
    ./social/discord.nix
    ./media
    ./gtk.nix
    ./office
    ./plasma.nix
    #./walker
  ];

  home.packages = with pkgs; [
    mission-center
    wineWowPackages.wayland
    ledger-live-desktop
    pinentry-gnome3
    gnumake
    postman
    qbittorrent-enhanced
    oversteer
  ];
}

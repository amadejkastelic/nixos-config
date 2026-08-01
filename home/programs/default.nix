{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./browsers
    ./media
    ./nix.nix
    ./gtk.nix
    ./qt.nix
    ./social
  ];

  home.packages =
    with pkgs;
    [
      gnumake
      hoppscotch
      iloader
      signal-desktop
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      kdePackages.dolphin
      kdePackages.kio-extras
      kdePackages.ark
      pinentry-gnome3
      kdePackages.plasma-systemmonitor
      wineWow64Packages.wayland
      ledger-live-desktop
      qbittorrent-enhanced
      kdePackages.partitionmanager
      inputs.proxsign.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}

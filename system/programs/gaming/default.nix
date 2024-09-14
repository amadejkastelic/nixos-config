{
  imports = [
    ./steam.nix
    ./switch.nix
    ./gamemode.nix
    ./gamescope.nix
  ];

  services.power-profiles-daemon.enable = true;
}

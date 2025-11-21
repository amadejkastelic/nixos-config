{ pkgs, ... }:
{
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    winetricks
    adwsteamgtk
    steam-run
    oversteer
    shadps4
    cemu
  ];
}

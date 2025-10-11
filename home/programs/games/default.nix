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
    # https://nixpkgs-tracker.ocfox.me/?pr=449160
    # shadps4
    # cemu
  ];
}

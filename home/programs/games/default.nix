{pkgs, ...}: {
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    winetricks
    adwsteamgtk
    steam-run
    shadps4
  ];
}

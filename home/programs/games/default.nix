{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    # inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    gamescope
    winetricks
    adwsteamgtk
    steam-run
    # steamtinkerlaunch
  ];
}

{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    # inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    winetricks
    adwsteamgtk
    steam-run
  ];
}

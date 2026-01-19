{ pkgs, ... }:
{
  imports = [
    ./discord.nix
    #./thunderbird.nix
  ];

  home.packages = [ pkgs.element-desktop ];
}

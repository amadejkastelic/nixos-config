{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];

  home.packages = [
    pkgs.onlyoffice-desktopeditors
  ];
}

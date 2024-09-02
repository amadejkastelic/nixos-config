{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = [
    pkgs.onlyoffice-bin
  ];
}

{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    libreoffice
    # kdePackages.kdenlive
    # obsidian
  ];
}

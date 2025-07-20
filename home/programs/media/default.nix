{ pkgs, self, ... }:
{
  imports = [
    ./mpv.nix
    ./noisetorch.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pulsemixer

    # images
    loupe
    krita

    # Apple Music
    self.packages.${pkgs.system}.cider
  ];
}

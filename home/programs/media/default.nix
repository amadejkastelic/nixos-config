{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./noisetorch.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pulsemixer

    # images
    loupe
    krita

    # Apple Music
    cider-2
  ];
}

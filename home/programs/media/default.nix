{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    #./rnnoise.nix
    ./spicetify.nix
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
  ];
}

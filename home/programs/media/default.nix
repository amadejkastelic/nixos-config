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

    # Apple Music
    # nix-store --add-fixed sha256 Cider-linux-appimage-x64.AppImage
    cider-2
  ];
}

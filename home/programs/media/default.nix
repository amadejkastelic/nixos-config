{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./mpv.nix ];

  home.packages =
    with pkgs;
    lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      gimp
      lxqt.pavucontrol-qt
      pulsemixer
      kdePackages.gwenview
      audacious
      cider-2
    ];
}

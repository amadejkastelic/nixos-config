{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    ./thunar.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = false;
  };
}

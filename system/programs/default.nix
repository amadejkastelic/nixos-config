{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    ./nautilus.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = false;
  };
}

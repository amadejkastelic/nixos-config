{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./idescriptor.nix
    ./noisetorch.nix
    ./obs.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = false;
  };
}

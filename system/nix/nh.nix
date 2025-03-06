{
  programs.nh = {
    enable = true;
    # monthly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
    flake = "/home/amadejk/Documents/dotfiles";
  };
}

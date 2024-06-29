{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    args = [
      #"--backend sdl"
    ];
  };
}

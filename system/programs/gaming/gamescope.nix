{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope_git;
    args = [
      "--backend sdl"
      "--adaptive-sync"
      "--force-grab-cursor"
    ];
    env = {
      ENABLE_GAMESCOPE_WSI = "1";
    };
  };
}

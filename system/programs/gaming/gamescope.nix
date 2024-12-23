{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    args = [
      "--backend wayland"
      "--force-grab-cursor"
      "-W 2560"
      "-H 1440"
      "-r 120"
      "-ef"
    ];
  };
}

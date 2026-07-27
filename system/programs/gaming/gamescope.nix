{
  config,
  pkgs,
  ...
}:
let
  gaming = config.workstation.gaming;
in
{
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    args = [
      "--backend wayland"
      "--force-grab-cursor"
      "-W ${toString gaming.width}"
      "-H ${toString gaming.height}"
      "-r ${toString gaming.refreshRate}"
      "-f"
    ];
  };
}

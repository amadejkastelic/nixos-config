{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    args = [
      "--backend sdl"
      "--force-grab-cursor"
      "-W 2560"
      "-H 1440"
      "-r 120"
      "-b"
      "-e"
    ];
  };

  /*
    nixpkgs.overlays = [
    (final: super: {
      gamescope = super.gamescope.overrideAttrs (old: {
        mesonFlags =
          old.mesonFlags
          ++ [
            "-Dc_args=-fno-omit-frame-pointer"
            "-Dc_link_args=-fno-omit-frame-pointer"
            "-Dcpp_args=-fno-omit-frame-pointer"
            "-Dcpp_link_args=-fno-omit-frame-pointer"
            "--buildtype=debugoptimized"
            "-Db_sanitize=address"
          ];
      });
    })
  ];
  */
}

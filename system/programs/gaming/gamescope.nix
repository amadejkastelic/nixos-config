{pkgs, ...}: {
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    args = [
      "--backend sdl"
      "--force-grab-cursor"
      "-w 2560"
      "-h 1440"
      "-r 120"
      "-b"
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

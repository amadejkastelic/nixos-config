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

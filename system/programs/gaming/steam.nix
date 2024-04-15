{
  pkgs,
  lib,
  config,
  ...
}: let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
  ];
in {
  programs.steam = {
    enable = true;

    extest.enable = false;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    gamescopeSession.enable = true;

    # fix gamescope inside steam
    package = pkgs.steam.override {
      extraEnv = {
        SDL_VIDEODRIVER = "x11";
      };

      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            extraBwrapArgs =
              (args.extraBwrapArgs or [])
              ++ [
                "--bind /tmp/hypr /tmp/hypr"
                "--ro-bind /etc/gamemode.ini /etc/gamemode.ini"
              ];
          });

      extraPkgs = pkgs:
        with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          gamemode
          hyprland
          hyprshade
        ];

      extraLibraries = pkgs: with pkgs; [gamemode pkgsi686Linux.gamemode];
    };
  };

  hardware = {
    # https://github.com/NixOS/nixpkgs/issues/47932#issuecomment-447508411
    opengl.driSupport32Bit = true;
    steam-hardware.enable = true;
  };
}

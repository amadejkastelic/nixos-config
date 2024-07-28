{
  pkgs,
  lib,
  config,
  ...
}: let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.hyprshade
  ];
in {
  programs.steam = {
    enable = true;

    extest.enable = false;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    # fix gamescope inside steam
    package = pkgs.steam.override {
      extraEnv = {
        SDL_VIDEODRIVER = "x11";
      };

      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            #extraPreBwrapCmds =
            #  (args.extraPreBwrapCmds or "")
            #  + ''
            #    cp /etc/static/gamemode.ini /tmp/gamemode.ini
            #    chmod 666 /tmp/gamemode.ini
            #  '';
            extraBwrapArgs =
              (args.extraBwrapArgs or [])
              ++ [
                "--bind /run/user/1000/hypr /tmp/hypr"
                #"--ro-bind /tmp/gamemode.ini /etc/gamemode.ini"
              ];
          });

      extraPkgs = pkgs:
        with pkgs; [
          gamemode
          config.programs.hyprland.package
          hyprshade
        ];

      extraLibraries = pkgs: with pkgs; [gamemode pkgsi686Linux.gamemode];
    };
  };

  hardware = {
    graphics.enable32Bit = true;
    steam-hardware.enable = true;
  };
}

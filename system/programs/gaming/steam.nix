{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs.steam = {
    enable = true;

    # fix gamescope inside steam
    package = pkgs.steam.override {
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

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    extest.enable = true;
    extraPackages = with pkgs; [
      hyprshade
    ];

    protontricks.enable = true;
    platformOptimizations.enable = true;
  };

  hardware = {
    graphics.enable32Bit = true;
    steam-hardware.enable = true;
  };
}

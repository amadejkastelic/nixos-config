{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.gnugrep
    pkgs.gnused
    pkgs.coreutils
    pkgs.gawk
  ];
  toggleGamemode = pkgs.writeShellScriptBin "toggle-gamemode" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances | grep instance | sed 's/://g' | cut -d' ' -f2 | tail -n 1)
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')
    if [ $HYPRGAMEMODE = 1 ] ; then
      hyprctl --batch "\
        keyword monitor "DP-2,2560x1440@120,0x0,1";\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
      exit
    fi
    hyprctl reload
  '';
in {
  environment.systemPackages = [
    toggleGamemode
  ];

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };

      custom = {
        start = "${toggleGamemode.outPath}/bin/toggle-gamemode";
        end = "${toggleGamemode.outPath}/bin/toggle-gamemode";
      };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}

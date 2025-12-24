{ pkgs, ... }:
let
  osu = pkgs.osu-lazer-bin.override { nativeWayland = true; };

  osu-wrapped = pkgs.symlinkJoin {
    name = "osu-lazer-wrapped";
    paths = [ osu ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mv $out/bin/osu! $out/bin/.osu!-unwrapped

      makeWrapper ${pkgs.gamemode}/bin/gamemoderun $out/bin/osu! \
        --add-flags "$out/bin/.osu!-unwrapped"
    '';
  };
in
{
  home.packages = [ osu-wrapped ];
}

{
  systems = [ "x86_64-linux" ];

  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        # instant repl with automatic flake loading
        repl = pkgs.callPackage ./repl { };

        wl-ocr = pkgs.callPackage ./wl-ocr { };

        bibata-cursors-svg = pkgs.callPackage ./bibata-cursors-svg { };

        sekiro-fps-unlock = pkgs.callPackage ./sekiro-fps-unlock { };
      };
    };
}

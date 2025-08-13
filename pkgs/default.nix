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

        catppuccin-plymouth = pkgs.callPackage ./catppuccin-plymouth { };

        wl-ocr = pkgs.callPackage ./wl-ocr { };

        bibata-cursors-svg = pkgs.callPackage ./bibata-cursors-svg { };

        # https://github.com/NixOS/nixpkgs/pull/427005
        cider = pkgs.callPackage ./cider { };
      };
    };
}

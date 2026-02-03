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

        openrgb-rc = (pkgs.callPackage ./openrgb-rc { }).withPlugins [
          pkgs.openrgb-plugin-effects
          pkgs.openrgb-plugin-hardwaresync
        ];

        z-ai-vision-mcp-server = pkgs.callPackage ./z-ai-vision-mcp-server { };

        magewell-usb-capture = pkgs.callPackage ./magewell-usb-capture { };

        ib-edavki = pkgs.callPackage ./ib-edavki { };

        jellyfin-plugin-intro-skipper = pkgs.callPackage ./jellyfin-plugin-intro-skipper { };
        jellyfin-plugin-file-transformation = pkgs.callPackage ./jellyfin-plugin-file-transformation { };
      };
    };
}

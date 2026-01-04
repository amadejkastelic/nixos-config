{
  self,
  inputs,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "gradle-7.6.6" ];
    };

    overlays = [
      (final: prev: {
        lib = prev.lib // {
          colors = import "${self}/lib/colors" prev.lib;
        };
      })
      inputs.nix-vscode-extensions.overlays.default
      inputs.firefox-addons.overlays.default
      inputs.cachyos-kernel.overlays.pinned

      # https://nixpkgs-tracker.ocfox.me/?pr=476347
      (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          preBuild = ''
            cp -r ${prev.electron.dist} electron-dist
            chmod -R u+w electron-dist
          '';
          buildPhase = ''
            runHook preBuild

            pnpm build
            pnpm exec electron-builder \
              --dir \
              -c.asarUnpack="**/*.node" \
              -c.electronDist="electron-dist" \
              -c.electronVersion=${prev.electron.version}

            runHook postBuild
          '';
        });
      })
    ];
  };
}

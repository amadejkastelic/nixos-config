{
  self,
  lib,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    overlays = [
      (final: prev: {
        lib =
          prev.lib
          // {
            colors = import "${self}/lib/colors" prev.lib;
          };
      })
      (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          version = "main";
          src = prev.fetchFromGitHub {
            owner = "Vencord";
            repo = "Vesktop";
            rev = "${old.version}";
            hash = "sha256-s3ndHHN8mqbzL40hMDXXDl+VV9pOk4XfnaVCaQvFFsg=";
          };
          pnpmDeps = old.pnpmDeps.overrideAttrs (x: {
            outputHash = "sha256-6ezEBeYmK5va3gCh00YnJzZ77V/Ql7A3l/+csohkz68=";
          });
        });
      })
    ];
  };
}

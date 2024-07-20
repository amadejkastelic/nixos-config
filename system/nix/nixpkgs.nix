{
  self,
  lib,
  inputs,
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
      inputs.nix-vscode-extensions.overlays.default
      inputs.catppuccin-vsc.overlays.default
      /*
        (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          version = "main";
          src = prev.fetchFromGitHub {
            owner = "Vencord";
            repo = "Vesktop";
            rev = "main";
            hash = "sha256-EF36HbbhTuAdwBEKqYgBBu7JoP1LJneU78bROHoKqDw=";
          };
          pnpmDeps = old.pnpmDeps.overrideAttrs (x: {
            outputHash = "sha256-6ezEBeYmK5va3gCh00YnJzZ77V/Ql7A3l/+csohkz68=";
          });
        });
      })
      */
    ];
  };
}

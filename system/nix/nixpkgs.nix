{
  self,
  inputs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        lib = prev.lib // {
          colors = import "${self}/lib/colors" prev.lib;
        };
      })
      inputs.nix-vscode-extensions.overlays.default
      inputs.firefox-addons.overlays.default
      inputs.cachyos-kernel.overlays.pinned
      # https://nixpkgs-tracker.ocfox.me/?pr=552075
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (_: pyprev: {
            nanoemoji = pyprev.nanoemoji.overrideAttrs (old: {
              src = old.src.overrideAttrs (_: {
                outputHash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
              });
            });
          })
        ];
      })
    ];
  };
}

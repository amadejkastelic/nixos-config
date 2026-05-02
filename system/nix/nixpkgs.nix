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
    ];
  };
}

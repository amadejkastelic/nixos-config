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
    ];
  };
}

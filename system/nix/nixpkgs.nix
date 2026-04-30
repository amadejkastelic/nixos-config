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
      # https://nixpkgs-tracker.ocfox.me/?pr=511658
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            fastmcp = python-prev.fastmcp.overridePythonAttrs (oldAttrs: {
              doCheck = false;
            });
          })
        ];
      })
    ];
  };
}

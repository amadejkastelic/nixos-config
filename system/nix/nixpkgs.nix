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
      # https://nixpkgs-tracker.ocfox.me/?pr=493376
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            picosvg = python-prev.picosvg.overridePythonAttrs (oldAttrs: {
              doCheck = false;
            });
          })
        ];
      })
      # https://nixpkgs-tracker.ocfox.me/?pr=486948
      (final: prev: {
        mcp-nixos = (
          prev.mcp-nixos.overrideAttrs (old: rec {
            version = "2.2.0";
            src = prev.fetchFromGitHub {
              owner = "utensils";
              repo = "mcp-nixos";
              rev = "v${version}";
              hash = "sha256-/3/MUCjUu4iQOEmgda61ztO2d6e/HPpjsF9Z7hTWYMc=";
            };
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.python3Packages.pytest-cov ];
          })
        );
      })
    ];
  };
}

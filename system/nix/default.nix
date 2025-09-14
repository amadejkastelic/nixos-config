{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # we need git for flakes
  environment.systemPackages = [ pkgs.git ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
    {
      # https://nixpkgs-tracker.ocfox.me/?pr=442624
      package = pkgs.lixPackageSets.latest.lix.overrideAttrs (old: {
        patches = old.patches ++ [
          (pkgs.fetchpatch {
            name = "lix-lowdown-1.4.0.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/858de5f47a1bfd33835ec97794ece339a88490f1.patch";
            hash = "sha256-FfLO2dFSWV1qwcupIg8dYEhCHir2XX6/Hs89eLwd+SY=";
          })
        ];
      });

      # pin the registry to avoid downloading and evaling a new nixpkgs version every time
      registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;

      # set the path for channels compat
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "/etc/nix/registry.json";

        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        accept-flake-config = false;

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      # Automatic garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
}

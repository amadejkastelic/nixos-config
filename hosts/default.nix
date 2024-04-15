{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    howdy = inputs.nixpkgs-howdy;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    ryzen = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./ryzen

          "${mod}/programs/hyprland.nix"
          "${mod}/programs/gaming"
          "${mod}/programs/noisetorch.nix"

          "${mod}/hardware/virtualisation.nix"

          "${mod}/services/gnome-services.nix"
          "${mod}/services/adb.nix"

          {
            home-manager = {
              users.amadejk.imports = homeImports."amadejk@ryzen";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}

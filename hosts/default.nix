{
  self,
  inputs,
  homeImports,
  ...
}:
{
  flake.nixosConfigurations =
    let
      # shorten paths
      inherit (inputs.nixpkgs.lib) nixosSystem;
      mod = "${self}/system";

      # get the basic config to build on top of
      inherit (import "${self}/system") desktop server;

      # get these into the module system
      specialArgs = { inherit inputs self; };
    in
    {
      ryzen = nixosSystem {
        inherit specialArgs;
        modules = desktop ++ [
          ./ryzen

          ./common/secrets.nix

          "${mod}/programs/hyprland"
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

          inputs.chaotic.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };

      server = nixosSystem {
        inherit specialArgs;
        modules = server ++ [
          ./server

          ./common/secrets.nix
        ];
      };
    };
}

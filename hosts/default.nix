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
          #"${mod}/programs/gnome"
          "${mod}/programs/gaming"
          "${mod}/programs/noisetorch.nix"

          "${mod}/hardware/virtualisation.nix"

          "${mod}/services/gnome-services.nix"

          {
            home-manager = {
              users.amadejk.imports = homeImports."amadejk@ryzen";
              extraSpecialArgs = specialArgs;
            };
          }
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

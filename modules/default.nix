{
  flake.nixosModules = {
    theme = import ./theme;
  };

  flake.homeManagerModules = {
    theme = import ./theme;
  };
}

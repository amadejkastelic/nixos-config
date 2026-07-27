{
  flake.modules = {
    config = import ./config.nix;
    hardware = import ./hardware;
    services = import ./services;
    workstation = import ./workstation.nix;
  };

  flake.homeManagerModules.workstation = import ./workstation.nix;
}

{
  flake.modules = {
    hardware = import ./hardware;
    services = import ./services;
  };

  flake.homeManagerModules = { };
}

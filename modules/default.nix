{
  flake.modules = {
    hardware = import ./hardware;
    programs = import ./programs;
    services = import ./services;
  };

  flake.homeManagerModules = { };
}

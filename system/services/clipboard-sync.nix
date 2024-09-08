{inputs, ...}: {
  imports = [inputs.clipboard-sync.nixosModules.default];

  services.clipboard-sync.enable = true;
}

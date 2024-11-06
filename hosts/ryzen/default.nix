{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  chaotic.scx = {
    enable = true;
    package = pkgs.scx_git.full;
    scheduler = "scx_lavd";
  };

  environment.systemPackages = with pkgs; [
    pcscliteWithPolkit
  ];

  hardware = {
    opentabletdriver.enable = true;
  };

  networking.hostName = "ryzen";

  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
  };
}

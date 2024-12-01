{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  services.scx = {
    enable = true;
    package = pkgs.scx.full;
    scheduler = "scx_lavd";
  };

  environment.systemPackages = with pkgs; [
    pcscliteWithPolkit
  ];

  hardware = {
    # https://nixpk.gs/pr-tracker.html?pr=360389
    # opentabletdriver.enable = true;
  };

  networking.hostName = "ryzen";

  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
  };
}

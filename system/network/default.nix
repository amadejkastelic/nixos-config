{
  lib,
  pkgs,
  ...
}:
# networking configuration
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services = {
    openssh = {
      enable = false;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved.enable = true;
  };

  # Don't wait for network startup
  # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}

{ pkgs, ... }:
{
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.tailscale-systray
  ];
}

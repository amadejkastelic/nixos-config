{ config, ... }:
let
  ports = [
    2049
    config.services.nfs.server.mountdPort
    config.services.nfs.server.lockdPort
  ];
in
{
  services.nfs.server = {
    enable = true;

    mountdPort = 4002;
    lockdPort = 4001;
  };

  networking.firewall.allowedTCPPorts = ports;
  networking.firewall.allowedUDPPorts = ports;
}

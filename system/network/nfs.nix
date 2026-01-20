let
  ports = [
    111
    2049
    4001
    4002
  ];
in
{
  boot.supportedFilesystems = [ "nfs" ];

  networking.firewall = {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };
}

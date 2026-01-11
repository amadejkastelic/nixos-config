{ config, ... }:
let
  hostName = config.networking.hostName;
in
{
  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    tailscaleAuth = {
      enable = true;
      virtualHosts = [ hostName ];
    };
  };

  services.tailscale.tls = {
    enable = true;

    nginx = {
      enable = true;
      virtualHosts = [ hostName ];
    };
  };
}

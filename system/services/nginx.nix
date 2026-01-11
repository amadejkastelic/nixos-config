{ config, ... }:
{
  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."${config.networking.hostName}" = {
      locations."/" = {
        return = "200 '${config.networking.hostName} server OK [nginx:${config.services.nginx.package.version}]'";
        extraConfig = "add_header Content-Type text/plain;";
      };
    };
  };

  services.tailscaleAuth.enable = true;

  # Tailscale funnel
  services.tailscale.funnel = {
    enable = true;
    host = "localhost";
    port = 80;
  };
}

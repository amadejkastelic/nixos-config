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

    virtualHosts."${hostName}" = {
      root = "/var/www/${hostName}";
      locations."/" = {
        extraConfig = ''
          default_type text/plain;
          try_files /index.html =404;
        '';
      };
    };

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

  systemd.tmpfiles.rules = [
    "d /var/www/${hostName} 0755 nginx nginx -"
    "f /var/www/${hostName}/index.html 0644 nginx nginx - '${hostName} server OK [nginx:${config.services.nginx.package.version}]'"
  ];
}

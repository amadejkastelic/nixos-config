{ config, ... }:
{
  homelab.subdomains = [ "headscale" ];

  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;
    nginx.enable = true;
    apiKey.enable = true;
    settings = {
      server_url = "https://headscale.${config.homelab.domain}";
      noise.private_key_path = config.sops.secrets."headscale/noise-private-key".path;
      database = {
        type = "sqlite";
        sqlite.write_ahead_log = true;
      };
      dns = {
        magic_dns = true;
        base_domain = "ts";
        override_local_dns = false;
      };
      derp = {
        urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
        auto_update_enabled = true;
      };
    };
  };

  sops.secrets."headscale/noise-private-key" =
    let
      sc = config.systemd.services.headscale.serviceConfig;
    in
    {
      owner = sc.User;
      group = sc.Group;
    };
}

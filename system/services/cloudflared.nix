{ config, ... }:
{
  services.cloudflared = {
    enable = true;

    tunnels."b6beb660-7290-4880-a91c-982e4986ec2b" = {
      credentialsFile = config.sops.secrets."cloudflare/tunnel-credentials".path;
      ingress."git.${config.homelab.domain}".service =
        "http://127.0.0.1:${toString config.services.forgejo.settings.server.HTTP_PORT}";
      ingress."gallery.${config.homelab.domain}".service =
        "http://127.0.0.1:${toString config.services.immich-public-proxy.port}";
      ingress."headscale.${config.homelab.domain}".service =
        "http://127.0.0.1:${toString config.services.headscale.port}";
      ingress."auth.${config.homelab.domain}".service =
        "http://127.0.0.1:${toString config.services.zitadel.settings.Port}";
      ingress."headplane.${config.homelab.domain}".service =
        "http://127.0.0.1:${toString config.services.headplane.settings.server.port}";
      default = "http_status:404";
    };
  };

  sops.secrets."cloudflare/tunnel-credentials" = { };
}

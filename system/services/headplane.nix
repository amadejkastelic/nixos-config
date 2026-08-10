{ config, ... }:
{
  homelab.subdomains = [ "headplane" ];

  services.headplane = {
    enable = true;
    nginx.enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 8090;
        base_url = "https://headplane.${config.homelab.domain}";
        data_path = "/var/lib/headplane";
        cookie_secret_path = config.sops.secrets."headplane/cookie-secret".path;
        cookie_secure = true;
      };
      headscale.api_key_path = config.services.headscale.apiKey.path;
      integration.proc.enabled = true;
      oidc = {
        enabled = true;
        issuer = "https://auth.${config.homelab.domain}";
        client_id = "headplane";
        client_secret_path = config.sops.secrets."headplane/oidc-client-secret".path;
        scope = "openid profile email";
        use_pkce = true;
        disable_api_key_login = true;
      };
    };
  };

  sops.secrets."headplane/oidc-client-secret" =
    let
      sc = config.systemd.services.headplane.serviceConfig;
    in
    {
      owner = sc.User;
      group = sc.Group;
    };
  sops.secrets."headplane/cookie-secret" =
    let
      sc = config.systemd.services.headplane.serviceConfig;
    in
    {
      owner = sc.User;
      group = sc.Group;
    };
}

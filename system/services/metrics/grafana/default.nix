let
  serverPort = 3000;
in
{
  imports = [ ./datasources.nix ];

  services.grafana = {
    enable = true;
    provision.enable = true;
    settings = {
      server = {
        http_port = serverPort;
        http_addr = "0.0.0.0";
        enable_gzip = true;
      };
      users = {
        allow_sign_up = false;
        default_theme = "dark";
      };
    };
  };
}

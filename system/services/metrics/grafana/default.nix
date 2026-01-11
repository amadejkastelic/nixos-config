{
  imports = [ ./datasources.nix ];

  services.grafana = {
    enable = true;
    nginx.enable = true;
    provision.enable = true;

    settings = {
      server = {
        http_port = 3000;
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

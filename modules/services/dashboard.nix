{
  config,
  lib,
  ...
}:

let
  cfg = config.services.homepage-dashboard.nginx;
in
{
  options.services.homepage-dashboard.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for homepage-dashboard";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose homepage-dashboard webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.homepage-dashboard.listenPort;
      description = "Port to expose homepage-dashboard webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "/";
      description = "Location path to expose homepage-dashboard webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts."${cfg.hostName}" = {
        locations."${cfg.location}" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}

{
  config,
  lib,
  ...
}:

let
  cfg = config.services.radarr.nginx;
in
{
  options.services.radarr.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for radarr";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose radarr webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.radarr.settings.server.port;
      description = "Port to expose radarr webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "radarr";
      description = "Location path to expose radarr webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr.settings.server.urlbase = "/${cfg.location}";

    services.nginx = {
      enable = true;

      virtualHosts."${cfg.hostName}" = {
        locations."/${cfg.location}/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}/${cfg.location}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}

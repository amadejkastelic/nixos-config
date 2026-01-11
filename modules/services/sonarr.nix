{
  config,
  lib,
  ...
}:

let
  cfg = config.services.sonarr.nginx;
in
{
  options.services.sonarr.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for sonarr";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose sonarr webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.sonarr.settings.server.port;
      description = "Port to expose sonarr webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "sonarr";
      description = "Location path to expose sonarr webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sonarr.settings.server.urlbase = "/${cfg.location}";

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

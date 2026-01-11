{
  config,
  lib,
  ...
}:

let
  cfg = config.services.prowlarr.nginx;
in
{
  options.services.prowlarr.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for prowlarr";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose prowlarr webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.prowlarr.settings.server.port;
      description = "Port to expose prowlarr webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "prowlarr";
      description = "Location path to expose prowlarr webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prowlarr.settings.server.urlbase = "/${cfg.location}";

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

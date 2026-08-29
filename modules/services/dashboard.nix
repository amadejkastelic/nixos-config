{
  config,
  lib,
  ...
}:

let
  cfg = config.services.glance.nginx;
  locationPath = if cfg.location == "" then "/" else "/${cfg.location}/";
in
{
  options.services.glance.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for glance";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose glance webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.glance.settings.server.port;
      description = "Port to expose glance webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Location path to expose glance webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts."${cfg.hostName}" = {
        locations."${locationPath}" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}${locationPath}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}

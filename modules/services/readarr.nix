{
  config,
  lib,
  ...
}:

let
  cfg = config.services.readarr.nginx;
in
{
  options.services.readarr.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for readarr";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose readarr webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.readarr.settings.server.port;
      description = "Port to expose readarr webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "readarr";
      description = "Location path to expose readarr webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.readarr.settings.server.urlbase = "/${cfg.location}";

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

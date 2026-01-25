{
  config,
  lib,
  ...
}:

let
  cfg = config.services.firefox-syncserver.nginx;
in
{
  options.services.firefox-syncserver.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for firefox-syncserver";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose firefox-syncserver webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = config.services.firefox-syncserver.settings.port;
      description = "Port to expose firefox-syncserver webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "firefox-syncserver";
      description = "Location path to expose firefox-syncserver webui through nginx";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts."${cfg.hostName}" = {
        locations."/${cfg.location}/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.services.headplane.nginx;
in
{
  options.services.headplane.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for Headplane";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "headplane.${config.homelab.domain}";
      description = "Virtual host name for the Headplane reverse proxy.";
    };
  };

  config = {
    services.nginx = lib.optionalAttrs cfg.enable {
      virtualHosts."${cfg.hostName}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.headplane.settings.server.port}";
        proxyWebsockets = true;
      };
    };
  };
}

{
  lib,
  pkgs,
  config,
  ...
}:
# https://github.com/immich-app/immich/discussions/1679
# Immich doesn't support a custom urlBase, so we have to expose it with tailscale
let
  cfg = config.services.immich.tailscale;
in
{
  options.services.immich.tailscale = {
    enable = lib.mkEnableOption "Enable tailscale routing for Immich";

    port = lib.mkOption {
      type = lib.types.int;
      default = 8443;
      description = "Port to expose Immich through tailscale";
    };
  };

  config = lib.mkIf (cfg.enable && config.services.tailscale.enable) {
    systemd.services.tailscale-serve-immich = {
      description = "Tailscale Serve for Immich";
      after = [
        "tailscaled.service"
        "immich-server.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe pkgs.tailscale} serve --https=${toString cfg.port} --bg http://${config.services.immich.host}:${toString config.services.immich.port}";
      };
    };
  };
}

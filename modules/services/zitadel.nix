{
  config,
  lib,
  ...
}:
let
  nginxCfg = config.services.zitadel.nginx;
  pgCfg = config.services.zitadel.postgres;
in
{
  options.services.zitadel.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for ZITADEL";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "auth.${config.homelab.domain}";
      description = "Virtual host name for the ZITADEL reverse proxy.";
    };
  };

  options.services.zitadel.postgres = {
    enable = lib.mkEnableOption "a local PostgreSQL database and role for ZITADEL";

    database = lib.mkOption {
      type = lib.types.str;
      default = "zitadel";
      description = "Name of the PostgreSQL database for ZITADEL.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "zitadel";
      description = "Name of the PostgreSQL role for ZITADEL (trust auth over localhost).";
    };
  };

  config = {
    services.nginx = lib.optionalAttrs nginxCfg.enable {
      virtualHosts."${nginxCfg.hostName}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.zitadel.settings.Port}";
        proxyWebsockets = true;
      };
    };

    services.postgresql = lib.optionalAttrs pgCfg.enable {
      ensureDatabases = [ pgCfg.database ];
      ensureUsers = [
        {
          name = pgCfg.user;
          ensureDBOwnership = true;
        }
      ];
      authentication = lib.mkBefore ''
        host all ${pgCfg.user} 127.0.0.1/32 trust
        host all ${pgCfg.user} ::1/128 trust
      '';
    };

    systemd.services.postgresql.postStart = lib.mkIf pgCfg.enable (
      lib.mkAfter ''
        ${config.services.postgresql.package}/bin/psql -tAc "ALTER ROLE ${pgCfg.user} WITH CREATEDB CREATEROLE;" || true
      ''
    );
  };
}

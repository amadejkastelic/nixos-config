{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bazarr-kdrama;
  nginxCfg = cfg.nginx;
  apiCfg = cfg.apiConfig;
  bazarrConfigurator = import ./bazarr-configurator.nix { inherit lib pkgs; };

  locationPath = if nginxCfg.location == "" then "/" else "/${nginxCfg.location}/";
in
{
  options.services.bazarr-kdrama.enable = lib.mkEnableOption "Bazarr KDrama service";

  options.services.bazarr-kdrama.package = lib.mkOption {
    type = lib.types.package;
    default = bazarrConfigurator.package;
    description = "Bazarr package to use";
  };

  options.services.bazarr-kdrama.dataDir = lib.mkOption {
    type = lib.types.str;
    default = "/var/lib/bazarr-kdrama";
    description = "The directory where Bazarr KDrama stores its data files.";
  };

  options.services.bazarr-kdrama.user = lib.mkOption {
    type = lib.types.str;
    default = "bazarr-kdrama";
    description = "User account under which Bazarr KDrama runs.";
  };

  options.services.bazarr-kdrama.group = lib.mkOption {
    type = lib.types.str;
    default = "bazarr-kdrama";
    description = "Group account under which Bazarr KDrama runs.";
  };

  options.services.bazarr-kdrama.listenPort = lib.mkOption {
    type = lib.types.port;
    default = 6768;
    description = "Port on which the Bazarr KDrama web interface should listen";
  };

  options.services.bazarr-kdrama.urlBase = lib.mkOption {
    type = lib.types.str;
    default = "/";
    description = "URL base for Bazarr KDrama when behind reverse proxy";
  };

  options.services.bazarr-kdrama.nginx = {
    enable = lib.mkEnableOption "Enable nginx reverse proxy for bazarr-kdrama";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Host name to expose bazarr-kdrama webui through nginx";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 6768;
      description = "Port to expose bazarr-kdrama webui through nginx";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Location path to expose bazarr-kdrama webui through nginx";
    };
  };

  options.services.bazarr-kdrama.apiConfig = bazarrConfigurator.apiConfigOptions;

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-bazarr-kdrama".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services = lib.mkMerge [
      {
        bazarr-kdrama = {
          description = "Bazarr KDrama";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.ffmpeg ];

          unitConfig.RequiresMountsFor = [ cfg.dataDir ];

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/bazarr --config '${cfg.dataDir}' --port ${toString cfg.listenPort} --no-update True";
            Restart = "on-failure";
            KillSignal = "SIGINT";
            SuccessExitStatus = [
              "0"
              "156"
            ];
          };
        };
      }
      (lib.mkIf apiCfg.enable {
        bazarr-kdrama.serviceConfig.LoadCredential = [ "api_key:${apiCfg.apiKeyPath}" ];

        bazarr-kdrama.preStart = bazarrConfigurator.mkPreStart {
          inherit (cfg) dataDir;
          port = cfg.listenPort;
          urlBase = cfg.urlBase;
        };

        bazarr-kdrama-config-settings = bazarrConfigurator.mkSettingsService {
          serviceName = "bazarr-kdrama";
          port = cfg.listenPort;
          urlBase = cfg.urlBase;
          apiConfig = apiCfg;
        };

        bazarr-kdrama-config-jellyfin = lib.mkIf (apiCfg.jellyfin != null) (
          bazarrConfigurator.mkJellyfinService {
            serviceName = "bazarr-kdrama";
            port = cfg.listenPort;
            urlBase = cfg.urlBase;
            apiConfig = apiCfg;
          }
        );
      })
    ];

    users.users = lib.mkIf (cfg.user == "bazarr-kdrama") {
      bazarr-kdrama = {
        group = cfg.group;
        extraGroups = [ "media" ];
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "bazarr-kdrama") {
      bazarr-kdrama = { };
    };

    services.nginx = lib.mkIf nginxCfg.enable {
      enable = true;

      virtualHosts."${nginxCfg.hostName}" = {
        locations."${locationPath}" = {
          proxyPass = "http://127.0.0.1:${toString nginxCfg.port}${locationPath}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };

    assertions = bazarrConfigurator.mkProviderAssertions apiCfg;
  };
}

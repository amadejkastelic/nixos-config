{
  config,
  lib,
  pkgs,
  ...
}:

let
  nginxCfg = config.services.prowlarr.nginx;
  apiCfg = config.services.prowlarr.apiConfig;
  apiConfigurator = import ./api-configurator.nix { inherit lib pkgs config; };

  hostConfig = {
    inherit (config.services.prowlarr.settings.server) port;
    urlBase = if nginxCfg.enable then "/${nginxCfg.location}" else "";
    passwordPath = apiCfg.hostPasswordPath;
    instanceName = "Prowlarr";
  };

  mkDefaultApplication =
    serviceName:
    let
      serviceConfig = config.services.${serviceName}.apiConfig;
      serviceNginxCfg = config.services.${serviceName}.nginx or { enable = false; };
      displayName = lib.concatMapStringsSep " " (
        word: lib.toUpper (builtins.substring 0 1 word) + builtins.substring 1 (-1) word
      ) (lib.splitString "-" serviceName);

      serviceBase = builtins.elemAt (lib.splitString "-" serviceName) 0;
      implementationName =
        lib.toUpper (builtins.substring 0 1 serviceBase) + builtins.substring 1 (-1) serviceBase;

      useNginx = config.services.${serviceName}.nginx.enable or false;
      servicePort = config.services.${serviceName}.settings.server.port;
      serviceLocation = config.services.${serviceName}.nginx.location or "";
      baseUrl =
        if useNginx then
          "http://127.0.0.1/${serviceLocation}"
        else
          "http://127.0.0.1:${toString servicePort}${serviceLocation}";
      prowlarrUrl =
        if useNginx then
          "http://127.0.0.1/${nginxCfg.location}"
        else
          "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}${nginxCfg.location}";
    in
    {
      name = displayName;
      implementationName = lib.mkDefault implementationName;
      apiKeyPath = lib.mkDefault serviceConfig.apiKeyPath;
      baseUrl = lib.mkDefault baseUrl;
      prowlarrUrl = lib.mkDefault prowlarrUrl;
    };

  defaultApplications =
    let
      arrServices = [
        "radarr"
        "sonarr"
        "sonarr-anime"
        "sonarr-kdrama"
      ];
      enabledArrServices = builtins.filter (s: config.services.${s}.enable or false) arrServices;
    in
    builtins.filter (app: app != { }) (map mkDefaultApplication enabledArrServices);

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

  options.services.prowlarr.apiConfig = {
    enable = lib.mkEnableOption "Enable API-based declarative configuration for prowlarr";

    apiKeyPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to API key secret file";
    };

    hostPasswordPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to host password secret file (optional for external auth)";
    };

    indexers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of Prowlarr indexer schema";
            };
            apiKeyPath = lib.mkOption {
              type = lib.types.path;
              description = "Path to file containing API key for indexer";
            };
          };
        }
      );
      default = [ ];
      description = "List of indexers to configure in Prowlarr";
    };

    applications = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the application";
            };
            implementationName = lib.mkOption {
              type = lib.types.str;
              description = "Implementation name (e.g., Radarr, Sonarr)";
            };
            apiKeyPath = lib.mkOption {
              type = lib.types.path;
              description = "Path to API key of the application";
            };
            baseUrl = lib.mkOption {
              type = lib.types.str;
              description = "Base URL of the application";
            };
            prowlarrUrl = lib.mkOption {
              type = lib.types.str;
              description = "Prowlarr URL for the application to connect to";
            };
            appProfileId = lib.mkOption {
              type = lib.types.int;
              default = 1;
              description = "Application profile ID";
            };
          };
        }
      );
      default = defaultApplications;
      description = "List of applications (Radarr, Sonarr instances) to connect to Prowlarr";
    };
  };

  config = lib.mkIf nginxCfg.enable {
    services.prowlarr.settings.server.urlbase = "/${nginxCfg.location}";

    services.nginx = {
      enable = true;

      virtualHosts."${nginxCfg.hostName}" = {
        locations."/${nginxCfg.location}/" = {
          proxyPass = "http://127.0.0.1:${toString nginxCfg.port}/${nginxCfg.location}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };

    systemd.services = lib.mkMerge [
      {
        prowlarr.serviceConfig.LoadCredential = [
          "api_key:${config.services.prowlarr.apiConfig.apiKeyPath}"
        ];

        prowlarr.preStart = ''
          config_file="${config.services.prowlarr.dataDir}/config.xml"
          if [ -f "$config_file" ]; then
            sed -i "s|<Port>.*</Port>|<Port>${toString config.services.prowlarr.settings.server.port}</Port>|g" "$config_file"
            sed -i "s|<UrlBase>.*</UrlBase>|<UrlBase>${
              config.services.prowlarr.settings.server.urlbase or ""
            }</UrlBase>|g" "$config_file"
            sed -i "s|<ApiKey>.*</ApiKey>|<ApiKey>$(cat $CREDENTIALS_DIRECTORY/api_key)</ApiKey>|g" "$config_file"
          fi
        '';
      }
      (lib.mkIf apiCfg.enable {
        prowlarr-config-host = apiConfigurator.mkHostConfigService "prowlarr" {
          inherit (apiCfg) apiKeyPath;
          inherit hostConfig;
          apiVersion = "v1";
        };

        prowlarr-config-indexers = lib.mkIf (apiCfg.indexers != [ ]) (
          apiConfigurator.mkIndexersService "prowlarr" {
            inherit (apiCfg) apiKeyPath indexers;
            inherit hostConfig;
            apiVersion = "v1";
          }
        );
      })
    ];
  };
}

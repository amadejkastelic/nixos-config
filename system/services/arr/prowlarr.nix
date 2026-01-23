{
  lib,
  config,
  pkgs,
  ...
}:
{
  services.prowlarr = {
    enable = true;

    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 9696;
    };

    environmentFiles = [
      (pkgs.writeText "prowlarr.env" ''
        PROWLARR__AUTH__METHOD=External
        PROWLARR__AUTH__REQUIRED=DisabledForLocalAddresses
      '')
    ];

    apiConfig = {
      enable = true;
      apiKeyPath = config.sops.secrets."prowlarr/api_key".path;

      indexerProxies = lib.optional config.services.flaresolverr.enable {
        name = "FlareSolverr";
        implementation = "FlareSolverr";
        hostUrl = "http://127.0.0.1:${toString config.services.flaresolverr.port}";
        requestTimeout = 60;
        tags = [ "cloudflare" ];
      };

      indexers = [
        {
          name = "YTS";
          tags = [ "movies" ];
        }
        {
          name = "Nyaa.si";
          tags = [ "anime" ];
        }
        {
          name = "SubsPlease";
          tags = [ "anime" ];
        }
      ]
      ++ lib.optionals config.services.flaresolverr.enable [
        {
          name = "1337x";
          tags = [
            "movies"
            "tv"
            "cloudflare"
          ];
        }
        {
          name = "AvistaZ";
          credentialsPaths = [
            {
              baseName = "username";
              path = config.sops.secrets."avistaz/username".path;
            }
            {
              baseName = "password";
              path = config.sops.secrets."avistaz/password".path;
            }
            {
              baseName = "pid";
              path = config.sops.secrets."avistaz/pid".path;
            }
          ];
          tags = [
            "kdrama"
            "cloudflare"
          ];
        }
      ];
    };
  };

  sops.secrets."prowlarr/api_key" = { };
  sops.secrets."avistaz/username" = { };
  sops.secrets."avistaz/password" = { };
  sops.secrets."avistaz/pid" = { };
}

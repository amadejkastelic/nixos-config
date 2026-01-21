{ config, pkgs, ... }:
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
      applications = [
        {
          name = "Radarr";
          implementationName = "Radarr";
          syncLevel = "FullSync";
          configContract = "RadarrSettings";
          apiKeyPath = config.sops.secrets."radarr/api_key".path;
          port = 7878;
        }
        {
          name = "Sonarr";
          implementationName = "Sonarr";
          syncLevel = "FullSync";
          configContract = "SonarrSettings";
          apiKeyPath = config.sops.secrets."sonarr/api_key".path;
          port = 8989;
        }
        {
          name = "Sonarr Anime";
          implementationName = "Sonarr";
          syncLevel = "FullSync";
          configContract = "SonarrSettings";
          apiKeyPath = config.sops.secrets."sonarr-anime/api_key".path;
          port = 8990;
        }
        {
          name = "Sonarr KDrama";
          implementationName = "Sonarr";
          syncLevel = "FullSync";
          configContract = "SonarrSettings";
          apiKeyPath = config.sops.secrets."sonarr-kdrama/api_key".path;
          port = 8991;
        }
      ];
    };
  };

  sops.secrets."prowlarr/api_key" = { };
}

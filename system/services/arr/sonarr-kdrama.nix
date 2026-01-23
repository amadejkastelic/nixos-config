{ config, ... }:
{
  services.sonarr-kdrama = {
    enable = true;
    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 8991;
      auth = {
        authenticationMethod = "External";
        authenticationRequired = "DisabledForLocalAddresses";
      };
    };

    apiConfig = {
      enable = true;
      apiKeyPath = config.sops.secrets."sonarr-kdrama/api_key".path;
      rootFolders = [
        { path = "${config.nas.mediaDir}/kdrama"; }
      ];
      downloadClients = [
        {
          name = "qBittorrent";
          implementationName = "qBittorrent";
          host = "127.0.0.1";
          port = 8088;
          apiKeyPath = config.sops.secrets."qbittorrent/api_key".path;
          category = "kdrama";
          importMode = "hardlink";
        }
      ];
    };
  };

  sops.secrets."sonarr-kdrama/api_key" = {
    owner = "sonarr-kdrama";
    group = "sonarr-kdrama";
  };
}

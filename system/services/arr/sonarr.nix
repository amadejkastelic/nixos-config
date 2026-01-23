{ config, ... }:
{
  services.sonarr = {
    enable = true;

    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 8989;
      auth = {
        authenticationMethod = "External";
        authenticationRequired = "DisabledForLocalAddresses";
      };
    };

    apiConfig = {
      enable = true;
      apiKeyPath = config.sops.secrets."sonarr/api_key".path;
      rootFolders = [
        { path = "${config.nas.mediaDir}/tv"; }
      ];
      downloadClients = [
        {
          name = "qBittorrent";
          implementationName = "qBittorrent";
          host = "127.0.0.1";
          port = 8088;
          apiKeyPath = config.sops.secrets."qbittorrent/api_key".path;
          category = "tv";
          importMode = "hardlink";
        }
      ];
    };
  };

  sops.secrets."sonarr/api_key" = {
    owner = "sonarr";
    group = "sonarr";
  };
}

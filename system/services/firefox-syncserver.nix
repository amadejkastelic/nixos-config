{ config, ... }:
{
  services.firefox-syncserver = {
    enable = true;
    nginx.enable = true;

    secrets = config.sops.secrets."firefox-syncserver-env".path;

    singleNode = {
      capacity = 2;
      hostname = config.networking.hostName;
    };

    settings.port = 5000;
  };

  services.mysqlBackup.databases = [ config.services.firefox-syncserver.database.name ];

  sops.secrets.firefox-syncserver-env = { };
}

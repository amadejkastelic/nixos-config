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
    };
  };

  sops.secrets."prowlarr/api_key" = { };
}

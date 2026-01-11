{ pkgs, ... }:
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
        PROWLARR__AUTH__METHOD=Extenral
        PROWLARR__AUTH__REQUIRED=DisabledForLocalAddresses
      '')
    ];
  };
}

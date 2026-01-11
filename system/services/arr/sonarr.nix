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
  };
}

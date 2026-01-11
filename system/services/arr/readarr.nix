{
  services.readarr = {
    enable = true;

    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 8787;
      auth = {
        authenticationMethod = "External";
        authenticationRequired = "DisabledForLocalAddresses";
      };
    };
  };
}

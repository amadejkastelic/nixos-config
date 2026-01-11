{
  services.prowlarr = {
    enable = true;

    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 9696;

      auth = {
        authenticationEnabled = false;
        authenticationMethod = "external";
        authenticationRequired = false;
      };
    };
  };
}

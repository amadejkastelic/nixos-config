{
  services.radarr = {
    enable = true;

    nginx.enable = true;

    settings = {
      log.analyticsEnabled = false;
      update.automatically = false;
      server.port = 7878;

      auth = {
        authenticationEnabled = false;
        authenticationMethod = "external";
        authenticationRequired = false;
      };
    };
  };
}

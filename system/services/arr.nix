{
  services.sonarr.enable = true;
  services.radarr.enable = true;
  services.prowlarr.enable = true;
  services.transmission = {
    enable = true;
    downloadDirPermissions = "0777";
    settings = {
      download-dir = "/media/Downloads";
      incomplete-dir-enabled = false;
    };
  };
  services.jellyfin.enable = true;
}

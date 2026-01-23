{
  services.jellyfin = {
    transcoding.enableHardwareEncoding = true;

    hardwareAcceleration = {
      enable = true;

      device = "/dev/dri/renderD128";
    };

    user = "jellyfin";
    group = "media";
  };

  users.users.jellyfin.extraGroups = [ "media" ];
}

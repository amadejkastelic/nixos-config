{
  services.jellyfin = {
    transcoding.enableHardwareEncoding = true;

    hardwareAcceleration = {
      enable = true;

      device = "/dev/dri/renderD128";
    };
  };
}

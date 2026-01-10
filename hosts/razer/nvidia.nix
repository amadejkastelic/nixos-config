{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaPersistenced = true;
    nvidiaSettings = false;
  };
}

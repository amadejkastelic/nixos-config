{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xhost
  ];

  services = {
    xserver = {
      enable = true;

      libinput = {
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat";
      };
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = false;
      };
      defaultSession = "plasmax11";
    };
    desktopManager.plasma6.enable = true;
  };
}

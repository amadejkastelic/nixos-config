{pkgs, ...}: {
  services = {
    udev.packages = with pkgs; [
      android-udev-rules
    ];
    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="6860", GROUP="adbusers"
    '';
  };

  programs.adb.enable = true;
}

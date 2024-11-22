{pkgs, ...}: {
  # Disable controller touchpad
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Logitech G923
  # https://github.com/berarma/new-lg4ff/pull/112
  hardware.new-lg4ff.enable = false;
  # services.udev.packages = with pkgs; [oversteer];
}

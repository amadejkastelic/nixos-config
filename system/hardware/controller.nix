{ pkgs, ... }:
{
  # Disable controller touchpad
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Logitech G923
  hardware.new-lg4ff.enable = true;
  services.udev.packages = with pkgs; [ oversteer ];
}

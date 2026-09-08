{ pkgs, ... }:
{
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gnome-settings-daemon
    ];

    gnome.gnome-keyring.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;
  };
}

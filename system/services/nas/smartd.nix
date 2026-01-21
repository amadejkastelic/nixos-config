{
  lib,
  pkgs,
  ...
}:
{
  services.smartd = {
    enable = true;
    autodetect = true;

    notifications = {
      x11.enable = false;

      mail = {
        enable = true;
        mailer = lib.getExe pkgs.msmtp;
      };
    };
  };
}

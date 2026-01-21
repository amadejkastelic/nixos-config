{
  lib,
  pkgs,
  ...
}:
{
  services.smartd = {
    enable = true;
    autodetect.enable = true;

    notifications = {
      x11.enable = false;

      mail = {
        enable = true;
        mailer = lib.getExe pkgs.msmtp;
      };
    };
  };
}

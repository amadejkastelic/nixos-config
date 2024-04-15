{pkgs, ...}: {
  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];

    udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    # pinentry fix
    dbus.packages = with pkgs; [
      gcr
    ];
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    id = ["28059814"];
  };
}

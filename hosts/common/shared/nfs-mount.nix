let
  options = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=600"
    "_netdev"
  ];
in
{
  fileSystems = {
    "/mnt/nas-data" = {
      device = "oblak.local:/storage/data";
      fsType = "nfs";
      options = options;
    };

    "/mnt/nas-media" = {
      device = "oblak.local:/storage/media";
      fsType = "nfs";
      options = options;
    };

    "/mnt/nas-backups" = {
      device = "oblak.local:/storage/backups";
      fsType = "nfs";
      options = options;
    };
  };
}

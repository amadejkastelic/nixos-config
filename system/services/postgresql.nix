{ config, ... }:
{
  services.postgresql.enable = true;

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;

    # Every day at 1 AM
    startAt = "*-*-* 01:00:00";
    compression = "zstd";

    location = "${config.nas.backupDir}/postgresql";
  };
}

{
  pkgs,
  config,
  ...
}:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.mysqlBackup = {
    enable = true;

    # Every day at 1:15 AM
    calendar = "01:15:00";

    compressionAlg = "zstd";
    compressionLevel = 6;

    location = "${config.nas.backupDir}/mysql";
  };
}

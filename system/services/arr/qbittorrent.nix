{
  services.qbittorrent = {
    enable = true;

    nginx.enable = true;

    webuiPort = 8088;

    extraArgs = [ "--confirm-legal-notice" ];

    serverConfig = {
      Core.AutoDeleteAddedTorrentFile = "Never";

      LegalNotice.Accepted = true;

      Preferences.WebUI = {
        LocalHostAuth = false;
        AuthSubnetWhitelist = "0.0.0.0/0";
      };

      BitTorrent.Session = {
        DefaultSavePath = "/todo";
        TempPath = "/todo";
        TempPathEnabled = true;
        AnonymousModeEnabled = true;
        GlobalMaxSeedingMinutes = -1;
        MaxActiveTorrents = -1;
        MaxActiveDownloads = -1;
        MaxActiveUploads = -1;
      };
    };
  };
}

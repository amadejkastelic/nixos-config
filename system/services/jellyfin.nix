{
  services.jellyfin = {
    enable = true;

    nginx.enable = true;

    openFirewall = true;

    transcoding = {
      # Manually enable enableHardwareEncoding in respective host configuration

      enableSubtitleExtraction = true;

      hardwareEncodingCodecs = {
        hevc = true;
        av1 = true;
      };

      hardwareDecodingCodecs = {
        vp9 = true;
        vp8 = true;
        vc1 = true;
        mpeg2 = true;
        hevcRExt12bit = true;
        hevcRExt10bit = true;
        hevc10bit = true;
        hevc = true;
        h264 = true;
        av1 = true;
      };
    };
  };
}

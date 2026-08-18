{ config, ... }:
{
  homelab.subdomains = [ "bazarr-kdrama" ];
  services.bazarr-kdrama = {
    enable = true;
    nginx = {
      enable = true;
      hostName = "bazarr-kdrama.${config.homelab.domain}";
    };

    apiConfig = {
      enable = true;
      apiKeyPath = config.sops.secrets."bazarr-kdrama/api_key".path;

      sonarr = {
        port = 8991;
        apiKeyPath = config.sops.secrets."sonarr-kdrama/api_key".path;
      };

      jellyfin = {
        apiKeyName = "Bazarr KDrama";
        seriesLibrary = [ "Korean Drama" ];
        updateMovieLibrary = false;
      };

      providers = [
        {
          name = "opensubtitlescom";
          usernamePath = config.sops.secrets."bazarr/opensubtitles/username".path;
          passwordPath = config.sops.secrets."bazarr/opensubtitles/password".path;
        }
        {
          name = "avistaz";
          cookiesPath = config.sops.secrets."avistaz/cookies".path;
        }
        { name = "gestdown"; }
      ];

      languages = { };
    };
  };

  sops.secrets."bazarr-kdrama/api_key" = {
    owner = "bazarr-kdrama";
    group = "bazarr-kdrama";
  };
}

let
  port = 8082;
in
{
  services.homepage-dashboard = {
    enable = true;
    nginx.enable = true;
    listenPort = port;

    allowedHosts = "*";

    settings = {
      title = "Amadej's Homelab";
    };

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ];

    services = [
      {
        Services = [
          {
            # TODO
            Immich = {
              href = "/immich";
              icon = "immich";
            };
          }
        ];
      }
      {
        Utilities = [
          {
            # TODO
            Traefik = {
              href = "/traefik";
              icon = "traefik";
            };
          }
          {
            Blocky = {
              href = "/blocky";
              icon = "blocky";
            };
          }
          {
            Vaultwarden = {
              href = "/vaultwarden";
              icon = "vaultwarden";
            };
          }
        ];
      }
      {
        Multimedia = [
          {
            Jellyfin = {
              icon = "jellyfin";
              href = "/jellyfin";
            };
          }
          {
            "Sonarr TV" = {
              icon = "sonarr";
              href = "/sonarr";
            };
          }
          {
            "Sonarr KDrama" = {
              icon = "sonarr";
              href = "/sonarr-kdrama";
            };
          }
          {
            "Sonarr Anime" = {
              icon = "sonarr";
              href = "/sonarr-anime";
            };
          }
          {
            Radarr = {
              icon = "radarr";
              href = "/radarr";
            };
          }
          {
            Bazarr = {
              icon = "bazarr";
              href = "/bazarr";
            };
          }
          {
            Prowlarr = {
              icon = "prowlarr";
              href = "/prowlarr";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent";
              href = "/qbittorrent";
            };
          }
        ];
      }
      {
        Monitoring = [
          {
            Prometheus = {
              href = "/prometheus";
              icon = "prometheus";
            };
          }
          {
            Grafana = {
              href = "/grafana";
              icon = "grafana";
            };
          }
        ];
      }
    ];

    bookmarks = [
      {
        Developer = [
          {
            Github = [
              {
                icon = "si-github";
                href = "https://github.com/";
              }
            ];
          }
          {
            "Nixos Search" = [
              {
                icon = "si-nixos";
                href = "https://search.nixos.org/packages";
              }
            ];
          }
          {
            "Nixos Wiki" = [
              {
                icon = "si-nixos";
                href = "https://nixos.wiki/";
              }
            ];
          }
        ];
      }
    ];
  };
}

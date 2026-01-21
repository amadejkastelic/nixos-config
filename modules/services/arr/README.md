# Arr Stack Declarative Configuration

This module provides API-based declarative configuration for arr services, eliminating the need for manual UI setup.

## Services

- **Radarr** - Movie management (port 7878)
- **Sonarr** - TV show management (port 8989)
- **Sonarr Anime** - Anime management (port 8990)
- **Sonarr KDrama** - KDrama management (port 8991)
- **Prowlarr** - Indexer manager (port 9696)

## Configuration

### Enable Declarative API Configuration

Add to your host configuration:

```nix
{
  services.radarr.apiConfig.enable = true;
  services.sonarr.apiConfig.enable = true;
  services.sonarr-anime.apiConfig.enable = true;
  services.sonarr-kdrama.apiConfig.enable = true;
  services.prowlarr.apiConfig.enable = true;
}
```

### Required Secrets

Add these to your `secrets.yaml`:

```yaml
radarr:
  api_key: "your-radarr-api-key"
  password: "your-radarr-password"

sonarr:
  api_key: "your-sonarr-api-key"
  password: "your-sonarr-password"

sonarr-anime:
  api_key: "your-sonarr-anime-api-key"
  password: "your-sonarr-anime-password"

sonarr-kdrama:
  api_key: "your-sonarr-kdrama-api-key"
  password: "your-sonarr-kdrama-password"

prowlarr:
  api_key: "your-prowlarr-api-key"
  password: "your-prowlarr-password"

qbittorrent:
  api_key: "your-qbittorrent-api-key"
```

## How It Works

### API Configurator Services

Each service runs three systemd services:

1. **`wait-for-api`** - Waits for the service API to be ready (up to 90 seconds)
2. **`api-config-host`** - Configures host settings (auth, ports, URL base)
3. **`api-config-rootfolders`** - Creates and manages root folders
4. **`api-config-downloadclients`** (Radarr/Sonarr only) - Configures qBittorrent
5. **`api-config-applications`** (Prowlarr only) - Syncs applications

### Idempotent Operations

- Root folders: Deletes folders not in config
- Download clients: Deletes clients not in config
- Applications: Syncs based on name (unique)

### Service Dependencies

Services depend on each other to ensure proper ordering:
- Prowlarr configures applications for Radarr/Sonarr
- Radarr/Sonarr configure download clients after hosts
- All services wait for API availability before configuration

## Default Configuration

### Media Paths (via `config.nas.mediaDir`)

- Radarr: `${config.nas.mediaDir}/movies`
- Sonarr: `${config.nas.mediaDir}/tv`
- Sonarr Anime: `${config.nas.mediaDir}/anime`
- Sonarr KDrama: `${config.nas.mediaDir}/kdrama`

### Download Client

All Radarr/Sonarr services use qBittorrent:
- Host: `127.0.0.1`
- Port: `8088`
- Implementation: `qBittorrent`

### Authentication

- Method: `External`
- Required: `DisabledForLocalAddresses`
- URL Base: `/service-name`

## Testing

```bash
# Build and switch
sudo nixos-rebuild switch --flake .#your-host

# Check service status
systemctl status radarr-api-config-host
systemctl status sonarr-api-config-downloadclients
systemctl status prowlarr-api-config-applications

# View logs
journalctl -u radarr-api-config-host -f
```

## Troubleshooting

Services fail if:
1. API keys are invalid or not accessible
2. qBittorrent API is not available
3. Port conflicts with other services
4. Service takes longer than 90 seconds to start

Check logs for specific error messages.

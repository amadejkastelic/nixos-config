# Jellyfin Declarative Configuration Implementation Plan

## Overview
Add fully declarative Jellyfin configuration via API with NVENC hardware acceleration.

## Requirements
- ✅ Avoid manual setup wizard (configure via API)
- ✅ Enable NVENC hardware acceleration (GTX 1070 Mobile)
- ✅ Create 2 users: admin (empty password), amadejk (empty password, non-admin, full media access)
- ✅ Create 4 libraries auto-generated from arr services:
  - Movies (radarr)
  - TV Shows (sonarr)
  - Korean Drama (sonarr-kdrama)
  - Anime (sonarr-anime)
- ✅ Server name: config.networking.hostName
- ✅ Metadata: defaults (en-US, US)
- ✅ Quick Connect: enabled
- ✅ Service ordering: sequential (wizard → auth → libraries → users)
- ✅ Error handling: fail hard on API failures
- ✅ Minimal NVENC configuration (hardwareAccelerationType = "nvenc")

---

## Files to Create

### 1. modules/services/jellyfin/util.nix
Utility functions for API integration:
- recursiveTransform: Convert kebab-case to PascalCase
- boolToString: Convert Nix bool to JSON string
- Shell script generation helpers

### 2. modules/services/jellyfin/api-configurator.nix
API configuration services with these functions:

- mkWaitForApiService: Wait for Jellyfin API
  - Poll /System/Info/Public endpoint
  - Retry logic with 180s timeout
  - Exit when Jellyfin responds

- mkSetupWizardService: Complete setup wizard
  - Check StartupWizardCompleted via API
  - POST /Startup/Configuration (server name, metadata defaults)
  - POST /Startup/User (admin user, empty password: "")
  - POST /Startup/RemoteAccess (enable remote access)
  - POST /Startup/Complete (mark wizard done)
  - Idempotent: skip if already completed

- mkAuthService: Authentication and token caching
  - POST /Users/AuthenticateByName (admin user, empty password)
  - Cache token to /run/jellyfin/auth-token (mode 600)
  - Export AUTH_HEADER environment variable
  - Handle token validation and re-auth

- mkLibrariesService: Create libraries from arr services
  - Auto-detect enabled arr services
  - Create 4 libraries based on arr paths:
    - Movies: from config.services.arr.radarr.mediaDirs
    - TV Shows: from config.services.arr.sonarr.mediaDirs
    - Korean Drama: from config.services.arr.sonarr-kdrama.mediaDirs
    - Anime: from config.services.arr.sonarr-anime.mediaDirs
  - Use /Library/VirtualFolders API
  - Delete libraries not in auto-generated list (declarative enforcement)
  - Create directories with systemd.tmpfiles

- mkUserService: Create amadejk user
  - POST /Users/New (amadejk, empty password: "")
  - Policy: isAdministrator = false, enableMediaPlayback = true, enableAllFolders = true
  - No other restrictions

---

## Files to Modify

### 3. modules/services/jellyfin.nix
Add API configuration options:

```nix
options.services.jellyfin.apiConfig = {
  enable = lib.mkEnableOption "Enable API-based declarative configuration";

  users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        policy = { ... };
      };
    });
    default = {};
  };
}
```

Auto-generate libraries from arr:
```nix
config.services.jellyfin.apiConfig.libraries = lib.mkMerge [
  (lib.mkIf (config.services.arr.radarr.enable or false) {
    Movies = {
      collectionType = "movies";
      paths = config.services.arr.radarr.mediaDirs;
    };
  })
  (lib.mkIf (config.services.arr.sonarr.enable or false) {
    "TV Shows" = {
      collectionType = "tvshows";
      paths = config.services.arr.sonarr.mediaDirs;
    };
  })
  (lib.mkIf (config.services.arr.sonarr-kdrama.enable or false) {
    "Korean Drama" = {
      collectionType = "tvshows";
      paths = config.services.arr.sonarr-kdrama.mediaDirs;
    };
  })
  (lib.mkIf (config.services.arr.sonarr-anime.enable or false) {
    Anime = {
      collectionType = "tvshows";
      paths = config.services.arr.sonarr-anime.mediaDirs;
    };
  })
];
```

Wire up systemd services after jellyfin.

### 4. system/services/jellyfin.nix
Enable API configuration:

```nix
services.jellyfin = {
  enable = true;
  nginx.enable = true;
  openFirewall = true;

  apiConfig = {
    enable = true;

    users = {
      admin = {
        password = null;  # Empty password
        policy = {
          isAdministrator = true;
          enableAllFolders = true;
          enableMediaPlayback = true;
        };
      };

      amadejk = {
        password = null;  # Empty password
        policy = {
          isAdministrator = false;
          enableAllFolders = true;
          enableMediaPlayback = true;
        };
      };
    };
  };

  transcoding = {
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
```

### 5. hosts/razer/jellyfin.nix
Remove incorrect VA-API configuration:
```nix
# DELETE:
hardwareAcceleration = {
  enable = true;
  device = "/dev/dri/renderD128";  # Wrong for NVIDIA (VA-API)
};
```

Add minimal NVENC configuration:
```nix
services.jellyfin = {
  transcoding = {
    enableHardwareEncoding = true;
    hardwareAccelerationType = "nvenc";  # Enable NVIDIA NVENC
  };

  user = "jellyfin";
  group = "media";
};

users.users.jellyfin.extraGroups = [ "media" ];
```

---

## Service Ordering (Sequential)

```
jellyfin.service (main Jellyfin service)
  ↓ (After)
jellyfin-wait-api.service (wait for API to be ready)
  ↓ (After, Requires)
jellyfin-setup-wizard.service (complete wizard, create admin)
  ↓ (After, Requires)
jellyfin-auth.service (login, cache token)
  ↓ (After, Requires)
jellyfin-libraries.service (create libraries from arr services)
  ↓ (After, Requires)
jellyfin-users.service (create amadejk user)
```

All services:
- Type = oneshot
- RemainAfterExit = true
- After and Requires dependencies (strict ordering)
- wantedBy = ["multi-user.target"]
- On failure: Exit with error code (fail hard)

---

## Technical Details

### Empty Password Support
- Wizard: POST /Startup/User with "Password": ""
- User creation: POST /Users/New with "Password": ""
- Auth: POST /Users/AuthenticateByName with "Pw": ""

### Authentication Flow
1. Setup wizard creates admin user (empty password)
2. Auth service logs in via /Users/AuthenticateByName (empty password)
3. Token cached to /run/jellyfin/auth-token (mode 600, owned by jellyfin)
4. Services use token in Authorization header:
   Authorization: MediaBrowser Client="jellyfin-nixos", Device="NixOS", DeviceId="jellyfin-nixos", Version="1.0.0", Token="<token>"

### Library Auto-Detection
- Check config.services.arr.<service>.enable
- If enabled, extract mediaDirs and create Jellyfin library
- Collection types: Movies → movies, TV/KDrama/Anime → tvshows
- Library names: Movies, TV Shows, Korean Drama, Anime

### Directory Setup
- Create library directories via systemd.tmpfiles
- Ownership: jellyfin:media
- Permissions: 0750 (rwxr-x---)
- Paths from arr services (auto-detected)

### NVENC Configuration
- GTX 1070 Mobile supports NVENC (H.264, H.265)
- No device path required (Jellyfin auto-detects via NVIDIA driver)
- Minimal config: hardwareAccelerationType = "nvenc"
- Existing hardwareEncodingCodecs and hardwareDecodingCodecs remain unchanged

### Error Handling (Fail Hard)
- Services exit with error code on API failures
- System rebuild will fail if configuration fails
- Logs will show detailed error information
- Idempotent: skip if already configured (safe to re-run)

---

## Summary

**2 NEW files:**
1. modules/services/jellyfin/util.nix
2. modules/services/jellyfin/api-configurator.nix

**3 MODIFIED files:**
3. modules/services/jellyfin.nix (add API options + auto-generate libraries)
4. system/services/jellyfin.nix (enable API config)
5. hosts/razer/jellyfin.nix (enable NVENC, remove VA-API)

**Features:**
- Fully declarative Jellyfin setup (no wizard)
- Libraries auto-sync with arr services
- NVENC hardware acceleration (properly enabled)
- Token caching for efficient API calls
- Idempotent services (skip if already configured)
- 2 users (admin + amadejk) with empty passwords
- Sequential service ordering
- Fail-hard error handling

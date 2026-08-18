{
  lib,
  pkgs,
  ...
}:
let
  boolStr = b: if b then "true" else "false";

  normalizeUrlBase = urlBase: if urlBase == "/" then "" else lib.removeSuffix "/" urlBase;

  connectionOpts = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Hostname or IP address of the instance";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = "Port of the instance";
      };

      apiKeyPath = lib.mkOption {
        type = lib.types.path;
        description = "Path to API key secret file of the instance";
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "/";
        description = "URL base if the instance is behind a reverse proxy";
      };

      ssl = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the instance uses SSL/TLS";
      };
    };
  };

  jellyfinOpts = lib.types.submodule {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8096";
        description = "Jellyfin server URL";
      };

      apiKeyName = lib.mkOption {
        type = lib.types.str;
        default = "Bazarr";
        description = "Name of the Jellyfin API key created by jellyfin-api-keys.service";
      };

      movieLibrary = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Jellyfin movie library names to refresh";
      };

      seriesLibrary = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Jellyfin series library names to refresh";
      };

      updateMovieLibrary = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Refresh Jellyfin movie libraries after subtitle downloads";
      };

      updateSeriesLibrary = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Refresh Jellyfin series libraries after subtitle downloads";
      };
    };
  };

  providerOpts = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum [
          "opensubtitlescom"
          "avistaz"
          "gestdown"
          "animetosho"
        ];
        description = "Bazarr subtitle provider name";
      };

      usernamePath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to username secret file";
      };

      passwordPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to password secret file";
      };

      cookiesPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to cookies secret file";
      };

      userAgent = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "User agent used for provider requests";
      };
    };
  };

  profileOpts = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Language profile name";
      };

      cutoff = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "code2 of the cutoff language, null for no cutoff";
      };

      items = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              language = lib.mkOption {
                type = lib.types.str;
                description = "Language code2";
              };

              hi = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Require hearing-impaired subtitles";
              };

              forced = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Require forced subtitles";
              };
            };
          }
        );
        description = "Languages included in the profile";
      };
    };
  };

  languageOpts = lib.types.submodule {
    options = {
      enabled = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "en" ];
        description = "Language code2 values to enable in Bazarr";
      };

      profiles = lib.mkOption {
        type = lib.types.listOf profileOpts;
        default = [
          {
            name = "English";
            cutoff = "en";
            items = [ { language = "en"; } ];
          }
        ];
        description = "Language profiles to manage; profiles absent from this list are deleted";
      };

      series = lib.mkOption {
        type = lib.types.submodule {
          options.defaultProfile = lib.mkOption {
            type = lib.types.str;
            default = "English";
            description = "Default language profile name for series";
          };
        };
        default = { };
      };

      movies = lib.mkOption {
        type = lib.types.submodule {
          options.defaultProfile = lib.mkOption {
            type = lib.types.str;
            default = "English";
            description = "Default language profile name for movies";
          };
        };
        default = { };
      };
    };
  };

  apiConfigOptions = {
    enable = lib.mkEnableOption "API-based declarative configuration";

    apiKeyPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to API key secret file";
    };

    sonarr = lib.mkOption {
      type = lib.types.nullOr connectionOpts;
      default = null;
      description = "Single Sonarr connection (Bazarr supports exactly one)";
    };

    radarr = lib.mkOption {
      type = lib.types.nullOr connectionOpts;
      default = null;
      description = "Single Radarr connection (Bazarr supports exactly one)";
    };

    jellyfin = lib.mkOption {
      type = lib.types.nullOr jellyfinOpts;
      default = null;
      description = "Jellyfin library refresh integration";
    };

    providers = lib.mkOption {
      type = lib.types.listOf providerOpts;
      default = [ ];
      description = "Subtitle providers to enable and configure";
    };

    languages = lib.mkOption {
      type = languageOpts;
      default = { };
      description = "Enabled languages, language profiles, and default profiles";
    };
  };

  providerLoadCredentials =
    providers:
    lib.concatMap (
      p:
      if p.name == "opensubtitlescom" then
        (
          lib.optional (p.usernamePath != null) "opensubtitlescom_username:${p.usernamePath}"
          ++ lib.optional (p.passwordPath != null) "opensubtitlescom_password:${p.passwordPath}"
        )
      else if p.name == "avistaz" then
        lib.optional (p.cookiesPath != null) "avistaz_cookies:${p.cookiesPath}"
      else
        [ ]
    ) providers;

  providerArgs =
    providers:
    lib.concatMapStringsSep " \\\n" (
      p:
      lib.concatStringsSep " \\\n" (
        [ ''--data-urlencode "settings-general-enabled_providers=${p.name}"'' ]
        ++ lib.optionals (p.name == "opensubtitlescom") [
          ''--data-urlencode "settings-opensubtitlescom-username=$(cat "$CREDENTIALS_DIRECTORY/opensubtitlescom_username")"''
          ''--data-urlencode "settings-opensubtitlescom-password=$(cat "$CREDENTIALS_DIRECTORY/opensubtitlescom_password")"''
        ]
        ++ lib.optionals (p.name == "avistaz") (
          [ ''--data-urlencode "settings-avistaz-cookies=$(cat "$CREDENTIALS_DIRECTORY/avistaz_cookies")"'' ]
          ++ lib.optional (
            p.userAgent != null
          ) ''--data-urlencode "settings-avistaz-user_agent=${p.userAgent}"''
        )
      )
    ) providers;

  connectionArgs = section: connection: ''
    --data-urlencode "settings-${section}-ip=${connection.host}" \
    --data-urlencode "settings-${section}-port=${toString connection.port}" \
    --data-urlencode "settings-${section}-base_url=${connection.baseUrl}" \
    --data-urlencode "settings-${section}-ssl=${boolStr connection.ssl}" \
    --data-urlencode "settings-${section}-apikey=$(cat "$CREDENTIALS_DIRECTORY/${section}_api_key")"'';

  unwrapProfiles = "if (type == \"object\" and has(\"data\")) then (.data // []) else . end // []";

  profilesSpec =
    languages: builtins.toJSON (map (p: { inherit (p) name cutoff items; }) languages.profiles);

  languagesEnabledArgs =
    languages:
    lib.concatMapStringsSep " \\\n" (
      code: ''--data-urlencode "languages-enabled=${code}"''
    ) languages.enabled;
in
{
  inherit apiConfigOptions;

  package = pkgs.bazarr.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace bazarr/utilities/video_analyzer.py \
        --replace-fail "if not language and und_default_language:" "if (not language or language == 'und') and und_default_language:"
    '';
  });

  mkProviderAssertions =
    apiConfig:
    let
      providers = apiConfig.providers;
    in
    [
      {
        assertion =
          !apiConfig.enable
          || lib.all (
            p: p.name != "opensubtitlescom" || (p.usernamePath != null && p.passwordPath != null)
          ) providers;
        message = "apiConfig.providers: opensubtitlescom requires usernamePath and passwordPath";
      }
      {
        assertion =
          !apiConfig.enable || lib.all (p: p.name != "avistaz" || p.cookiesPath != null) providers;
        message = "apiConfig.providers: avistaz requires cookiesPath";
      }
    ];

  mkPreStart =
    {
      dataDir,
      port,
      urlBase,
    }:
    ''
      set -eu

      config_dir="${dataDir}/config"
      config_yaml="$config_dir/config.yaml"

      mkdir -p "$config_dir"
      touch "$config_yaml"

      export BAZARR_API_KEY=$(cat "$CREDENTIALS_DIRECTORY/api_key")

      ${lib.getExe pkgs.yq-go} -i '
        del(.api_key) |
        .general.base_url = "${urlBase}" |
        .general.port = ${toString port} |
        .auth.apikey = strenv(BAZARR_API_KEY)
      ' "$config_yaml"
    '';

  mkSettingsService =
    {
      serviceName,
      port,
      urlBase,
      apiConfig,
    }:
    let
      cfg = apiConfig;
      apiKeyPath = cfg.apiKeyPath;
      baseUrl = "http://127.0.0.1:${toString port}${normalizeUrlBase urlBase}";
      capitalizedName =
        lib.toUpper (builtins.substring 0 1 serviceName) + builtins.substring 1 (-1) serviceName;
      waitScript = import ./bazarr-wait-for-api.nix {
        inherit
          pkgs
          serviceName
          port
          apiKeyPath
          ;
        urlBase = normalizeUrlBase urlBase;
      };
    in
    {
      description = "Configure ${capitalizedName} settings via API";
      after = [ "${serviceName}.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        LoadCredential = [
          "api_key:${cfg.apiKeyPath}"
        ]
        ++ lib.optional (cfg.sonarr != null) "sonarr_api_key:${cfg.sonarr.apiKeyPath}"
        ++ lib.optional (cfg.radarr != null) "radarr_api_key:${cfg.radarr.apiKeyPath}"
        ++ providerLoadCredentials cfg.providers;
        ExecStartPre = "${waitScript}";
      };

      script =
        let
          sonarrArgs = lib.optionalString (cfg.sonarr != null) (connectionArgs "sonarr" cfg.sonarr);
          radarrArgs = lib.optionalString (cfg.radarr != null) (connectionArgs "radarr" cfg.radarr);
        in
        ''
          set -eu

          if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "$CREDENTIALS_DIRECTORY/api_key" ]; then
            API_KEY=$(cat "$CREDENTIALS_DIRECTORY/api_key")
          else
            API_KEY=$(cat ${cfg.apiKeyPath})
          fi

          BASE_URL="${baseUrl}"
          AUTH_HEADER="X-API-KEY: $API_KEY"

          EXISTING_PROFILES=$(${pkgs.curl}/bin/curl -sf -H "$AUTH_HEADER" "$BASE_URL/api/system/languages/profiles" \
            | ${pkgs.jq}/bin/jq '${unwrapProfiles}')

          PROFILES_JSON=$(echo '${profilesSpec cfg.languages}' | ${pkgs.jq}/bin/jq -c --argjson existing "$EXISTING_PROFILES" '
            [ .[] | . as $spec
              | ([$existing[] | select(.name == $spec.name) | .profileId][0] // null) as $pid
              | ([ $spec.items | to_entries[]
                  | { id: (.key + 1),
                      language: .value.language,
                      hi: (if .value.hi then "True" else "False" end),
                      forced: (if .value.forced then "True" else "False" end),
                      audio_exclude: "False",
                      audio_only_include: "False" } ]) as $items
              | { profileId: $pid,
                  name: $spec.name,
                  cutoff: (if $spec.cutoff == null then null
                           else ([$items[] | select(.language == $spec.cutoff)][0].id) end),
                  items: $items,
                  mustContain: [],
                  mustNotContain: [],
                  originalFormat: null,
                  tag: null } ]')

          RESPONSE=$(${pkgs.curl}/bin/curl -s -w "\n%{http_code}" -X POST -H "$AUTH_HEADER" \
            --data-urlencode "settings-general-use_sonarr=${boolStr (cfg.sonarr != null)}" \
            ${
              lib.optionalString (cfg.languages.enabled != [ ])
                ''--data-urlencode "settings-general-default_und_embedded_subtitles_lang=${lib.head cfg.languages.enabled}"''
            } \
            --data-urlencode "settings-general-use_radarr=${boolStr (cfg.radarr != null)}" \
            ${sonarrArgs} \
            ${radarrArgs} \
            ${providerArgs cfg.providers} \
            ${languagesEnabledArgs cfg.languages} \
            --data-urlencode "languages-profiles=$PROFILES_JSON" \
            "$BASE_URL/api/system/settings")

          HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
          if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
            echo "ERROR: Failed to configure ${capitalizedName} settings (HTTP $HTTP_CODE)" >&2
            echo "$RESPONSE" | sed '$d' >&2
            exit 1
          fi

          UPDATED_PROFILES=$(${pkgs.curl}/bin/curl -sf -H "$AUTH_HEADER" "$BASE_URL/api/system/languages/profiles" \
            | ${pkgs.jq}/bin/jq '${unwrapProfiles}')

          SERIES_ID=$(echo "$UPDATED_PROFILES" | ${pkgs.jq}/bin/jq -r --arg n "${cfg.languages.series.defaultProfile}" '.[] | select(.name == $n) | .profileId' | head -n1)
          MOVIES_ID=$(echo "$UPDATED_PROFILES" | ${pkgs.jq}/bin/jq -r --arg n "${cfg.languages.movies.defaultProfile}" '.[] | select(.name == $n) | .profileId' | head -n1)

          if [ -z "$SERIES_ID" ] || [ "$SERIES_ID" = "null" ] || [ -z "$MOVIES_ID" ] || [ "$MOVIES_ID" = "null" ]; then
            echo "ERROR: Failed to resolve default language profile ids" >&2
            exit 1
          fi

          RESPONSE=$(${pkgs.curl}/bin/curl -s -w "\n%{http_code}" -X POST -H "$AUTH_HEADER" \
            --data-urlencode "settings-general-serie_default_enabled=true" \
            --data-urlencode "settings-general-serie_default_profile=$SERIES_ID" \
            --data-urlencode "settings-general-movie_default_enabled=true" \
            --data-urlencode "settings-general-movie_default_profile=$MOVIES_ID" \
            "$BASE_URL/api/system/settings")

          HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
          if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
            echo "ERROR: Failed to set default language profiles (HTTP $HTTP_CODE)" >&2
            echo "$RESPONSE" | sed '$d' >&2
            exit 1
          fi
        '';
    };

  mkJellyfinService =
    {
      serviceName,
      port,
      urlBase,
      apiConfig,
    }:
    let
      jf = apiConfig.jellyfin;
      apiKeyPath = apiConfig.apiKeyPath;
      baseUrl = "http://127.0.0.1:${toString port}${normalizeUrlBase urlBase}";
      capitalizedName =
        lib.toUpper (builtins.substring 0 1 serviceName) + builtins.substring 1 (-1) serviceName;
      slug = lib.toLower (lib.replaceStrings [ " " ] [ "-" ] jf.apiKeyName);
      waitScript = import ./bazarr-wait-for-api.nix {
        inherit
          pkgs
          serviceName
          port
          apiKeyPath
          ;
        urlBase = normalizeUrlBase urlBase;
      };
      seriesLibraryArgs = lib.concatMapStringsSep " \\\n" (
        name: ''--data-urlencode "settings-jellyfin-series_library=${name}"''
      ) jf.seriesLibrary;
      movieLibraryArgs = lib.concatMapStringsSep " \\\n" (
        name: ''--data-urlencode "settings-jellyfin-movie_library=${name}"''
      ) jf.movieLibrary;
    in
    {
      description = "Configure ${capitalizedName} Jellyfin integration via API";
      after = [
        "${serviceName}.service"
        "jellyfin-api-keys.service"
      ];
      wants = [ "jellyfin-api-keys.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        LoadCredential = [
          "api_key:${apiConfig.apiKeyPath}"
          "jellyfin_api_key:/run/jellyfin/api-keys/${slug}.txt"
        ];
        ExecStartPre = "${waitScript}";
      };

      script = ''
        set -eu

        if [ -n "''${CREDENTIALS_DIRECTORY:-}" ] && [ -f "$CREDENTIALS_DIRECTORY/api_key" ]; then
          API_KEY=$(cat "$CREDENTIALS_DIRECTORY/api_key")
        else
          API_KEY=$(cat ${apiConfig.apiKeyPath})
        fi

        BASE_URL="${baseUrl}"
        AUTH_HEADER="X-API-KEY: $API_KEY"
        JF_KEY=$(cat "$CREDENTIALS_DIRECTORY/jellyfin_api_key")

        RESPONSE=$(${pkgs.curl}/bin/curl -s -w "\n%{http_code}" -X POST -H "$AUTH_HEADER" \
          --data-urlencode "settings-general-use_jellyfin=true" \
          --data-urlencode "settings-jellyfin-url=${jf.url}" \
          --data-urlencode "settings-jellyfin-apikey=$JF_KEY" \
          --data-urlencode "settings-jellyfin-update_series_library=${boolStr jf.updateSeriesLibrary}" \
          --data-urlencode "settings-jellyfin-update_movie_library=${boolStr jf.updateMovieLibrary}" \
          ${seriesLibraryArgs} \
          ${movieLibraryArgs} \
          "$BASE_URL/api/system/settings")

        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
        if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
          echo "ERROR: Failed to configure ${capitalizedName} Jellyfin integration (HTTP $HTTP_CODE)" >&2
          echo "$RESPONSE" | sed '$d' >&2
          exit 1
        fi
      '';
    };
}

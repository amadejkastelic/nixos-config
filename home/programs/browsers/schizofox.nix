{
  inputs,
  pkgs,
  config,
  ...
}:
let
  startPagePrefs = "cad014b9ee124fd704ea0f51be2f73bfc3349588a40d189dcba79c484d35183eb373638bc54f6b19a1455c4ca2df381259d97999446bc4bfef4720783438530f26eed9e2ca3f81bcfc149bae";

  styles = [
    "advent-of-code"
    "arch-wiki"
    "claude"
    "codeberg"
    "duckduckgo"
    "freedesktop"
    "github"
    "gmail"
    "google"
    "hacker-news"
    "home-manager-options-search"
    "linkedin"
    "nixos-manual"
    "nixos-search"
    "ollama"
    "perplexity"
    "pypi"
    "reddit"
    "stack-overflow"
    "startpage"
    "twitch"
    "twitter"
    "wiki.nixos.org"
    "wikipedia"
    "youtube"
  ];
  palette =
    inputs.nix-userstyles.inputs.nix-colors.colorSchemes."catppuccin-${config.catppuccin.flavor}".palette;
  userStyles =
    inputs.nix-userstyles.packages.${pkgs.stdenv.hostPlatform.system}.mkUserStyles palette
      styles;
in
{
  imports = [
    inputs.schizofox.homeManagerModule
  ];

  home.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = 1;

  programs.schizofox = {
    enable = true;

    search = {
      defaultSearchEngine = "Startpage";
      removeEngines = [
        "DuckDuckGo"
        "Wikipedia (en)"
      ];
      addEngines = [
        {
          Name = "Startpage";
          Description = "Uses Google's indexer without its logging";
          Method = "GET";
          URLTemplate = "https://startpage.com/sp/search?query={searchTerms}&prfe=${startPagePrefs}";
        }
        {
          Name = "Youtube";
          Description = "Search Youtube";
          Method = "GET";
          URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
          Alias = "!yt";
        }
        {
          Name = "Nix Packages";
          Description = "Search NixPkgs";
          Method = "GET";
          URLTemplate = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";
          Alias = "!np";
        }
        {
          Name = "Nix Options";
          Description = "Search options";
          Method = "GET";
          URLTemplate = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";
          Alias = "!no";
        }
        {
          Name = "Nix Hydra";
          Description = "Search Nix Hydra Builds";
          Method = "GET";
          URLTemplate = "https://hydra.nixos.org/search?query={searchTerms}";
          Alias = "!nh";
        }
        {
          Name = "Home Manager Options";
          Description = "Search hm options";
          Method = "GET";
          URLTemplate = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
          Alias = "!hm";
        }
        {
          Name = "Catppuccin Options";
          Description = "Search Catppuccin options";
          Method = "GET";
          URLTemplate = "https://nix.catppuccin.com/search/rolling/?option_scope=1&query={searchTerms}";
          Alias = "!co";
        }
        {
          Name = "Github Code";
          Description = "Search Github code";
          Method = "GET";
          URLTemplate = "https://github.com/search?type=code&q={searchTerms}";
          Alias = "!gh";
        }
        {
          Name = "Github Repositories";
          Description = "Search Github repositories";
          Method = "GET";
          URLTemplate = "https://github.com/search?type=repositories&q={searchTerms}";
          Alias = "!ghr";
        }
        {
          Name = "Reddit";
          Description = "Search Reddit";
          Method = "GET";
          URLTemplate = "https://old.reddit.com/search?q={searchTerms}";
          Alias = "!r";
        }
        {
          Name = "Perplexity";
          Description = "Search Perplexity";
          Alias = "!pe";
          Method = "GET";
          URLTemplate = "https://www.perplexity.ai/search?q={searchTerms}";
        }
      ];
    };

    security = {
      sandbox.enable = false;
      noSessionRestore = false;
      userAgent = "Mozilla/5.0 (X11; Linux i686; rv:128.5) Gecko/20100101 Firefox/128.5";
    };

    misc = {
      drm.enable = true;
      contextMenu.enable = true;
      disableWebgl = false;
    };

    theme.extraUserContent = builtins.readFile "${userStyles}";

    settings = {
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "media.av1.enabled" = true;
      "gfx.x11-egl.force-enabled" = true;
      "widget.dmabuf.force-enabled" = true;

      "browser.ctrlTab.sortByRecentlyUsed" = true;
      # This makes websites prefer dark theme (in theory)
      "layout.css.prefers-color-scheme.content-override" = 0;
      # Scaling
      "layout.css.devPixelsPerPx" = 1.75;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      # Leaving this on breaks a lot
      "privacy.resistFingerprinting" = false;
      # Disable letterboxing
      "privacy.resistFingerprinting.letterboxing" = false;
      "permissions.fullscreen.allowed" = true;
      "dom.webnotifications.enabled" = true;
      # Restore previous session
      "browser.startup.page" = 3;
      "dom.event.clipboardevents.enabled" = true;
      # Remove window control buttons
      "browser.tabs.inTitlebar" = 0;
      # Scroll
      "general.autoScroll" = true;
      "general.smoothScroll" = true;
      "extensions.update.enabled" = true;
    };

    extensions = {
      enableDefaultExtensions = true;
      darkreader.enable = true;
      simplefox.enable = false;
      enableExtraExtensions = true;
      extraExtensions =
        let
          mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        in
        {
          "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}".install_url = mkUrl "auto-tab-discard";
          "sponsorBlocker@ajay.app".install_url = mkUrl "sponsorblock";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = mkUrl "bitwarden-password-manager";
          "idcac-pub@guus.ninja".install_url = mkUrl "istilldontcareaboutcookies";
          "{96ef5869-e3ba-4d21-b86e-21b163096400}".install_url = mkUrl "font-fingerprint-defender";
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url = mkUrl "return-youtube-dislikes";
          "uBlock0@raymondhill.net".install_url = mkUrl "ublock-origin";
          "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}".install_url = mkUrl "old-reddit-redirect";
          "{84601290-bec9-494a-b11c-1baa897a9683}".install_url = mkUrl "ctrl-number-to-switch-tabs";
          "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".install_url = mkUrl "violentmonkey";
          "firefox@betterttv.net".install_url = mkUrl "betterttv";
          "{7c42eea1-b3e4-4be4-a56f-82a5852b12dc}".install_url = mkUrl "phantom-app";
          "{194d0dc6-7ada-41c6-88b8-95d7636fe43c}".install_url = mkUrl "csgofloat";

          # Disable
          "{c607c8df-14a7-4f28-894f-29e8722976af}" = null; # Temporary containers
          "7esoorv3@alefvanoon.anonaddy.me" = null; # LibRedirect
        };
    };
  };
}

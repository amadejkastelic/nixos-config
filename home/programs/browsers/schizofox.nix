{inputs, ...}: let
  startPagePrefs = "cad014b9ee124fd704ea0f51be2f73bfc3349588a40d189dcba79c484d35183eb373638bc54f6b19a1455c4ca2df381259d97999446bc4bfef4720783438530f26eed9e2ca3f81bcfc149bae";
in {
  imports = [
    inputs.schizofox.homeManagerModule
  ];

  home.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = 1;

  programs.schizofox = {
    enable = true;

    search = {
      defaultSearchEngine = "Startpage";
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
          Name = "Home Manager Options";
          Description = "Search hm options";
          Method = "GET";
          URLTemplate = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
          Alias = "!hm";
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
      ];
    };

    security = {
      noSessionRestore = false;
      userAgent = "Mozilla/5.0 (X11; Linux i686; rv:128.1) Gecko/20100101 Firefox/128.1";
    };

    misc = {
      drm.enable = true;
      drmFix = true;
      contextMenu.enable = true;
      disableWebgl = false;
    };

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
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      # Leaving this on breaks a lot
      "privacy.resistFingerprinting" = false;
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
    };

    extensions = {
      enableDefaultExtensions = true;
      darkreader.enable = true;
      simplefox.enable = false;
      enableExtraExtensions = true;
      extraExtensions = let
        mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
      in {
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}".install_url = mkUrl "auto-tab-discard";
        "sponsorBlocker@ajay.app".install_url = mkUrl "sponsorblock";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = mkUrl "bitwarden-password-manager";
        "idcac-pub@guus.ninja".install_url = mkUrl "istilldontcareaboutcookies";
        "{96ef5869-e3ba-4d21-b86e-21b163096400}".install_url = mkUrl "font-fingerprint-defender";
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url = mkUrl "return-youtube-dislikes";
        "uBlock0@raymondhill.net".install_url = mkUrl "ublock-origin";
        "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}".install_url = mkUrl "old-reddit-redirect";
        "{84601290-bec9-494a-b11c-1baa897a9683}".install_url = mkUrl "ctrl-number-to-switch-tabs";
        "firefox@tampermonkey.net".install_url = mkUrl "tampermonkey";
        "firefox@betterttv.net".install_url = mkUrl "betterttv";

        # Disable
        "{c607c8df-14a7-4f28-894f-29e8722976af}" = null; # Temporary containers
        "7esoorv3@alefvanoon.anonaddy.me" = null; # LibRedirect
      };
    };
  };
}

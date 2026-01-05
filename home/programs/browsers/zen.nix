{
  pkgs,
  inputs,
  ...
}:
let
  startPagePrefs = "cad014b9ee124fd704ea0f51be2f73bfc3349588a40d189dcba79c484d35183eb373638bc54f6b19a1455c4ca2df381259d97999446bc4bfef4720783438530f26eed9e2ca3f81bcfc149bae";
  nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

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
  palette = inputs.nix-userstyles.inputs.nix-colors.colorSchemes."catppuccin-mocha".palette;
  userStyles =
    inputs.nix-userstyles.packages.${pkgs.stdenv.hostPlatform.system}.mkUserStyles palette
      styles;
in
{
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default = {
      settings = {
        browser = {
          tabs = {
            warnOnClose = false;
            inTitlebar = 0;
          };
          ctrlTab.sortByRecentlyUsed = true;
          # Restore previous session
          startup.page = 3;
        };

        layout.css = {
          # Prefer dark theme
          prefers-color-scheme.content-override = 0;
          devPixelsPerPx = 1.5;
        };

        widget.use-xdg-desktop-portal.file-picker = true;

        dom = {
          webnotifications.enabled = true;
          event.clipboardevents.enabled = true;
        };

        general = {
          autoScroll = true;
          smoothScroll = true;
        };

        extensions.update.enabled = false;
      };

      userContent = builtins.readFile userStyles;

      extensions.packages = with pkgs.firefox-addons; [
        auto-tab-discard
        darkreader
        ublock-origin
        sponsorblock
        bitwarden
        istilldontcareaboutcookies
        return-youtube-dislikes
        old-reddit-redirect
        ctrl-number-to-switch-tabs
        violentmonkey
        betterttv
        csgofloat
        metamask
      ];

      search = {
        force = true;
        default = "@sp";
        engines = {
          startpage = {
            name = "Startpage";
            urls = [
              {
                template = "https://startpage.com/sp/search?query={searchTerms}";
                params = [
                  {
                    name = "prfe";
                    value = startPagePrefs;
                  }
                ];
              }
            ];
            definedAliases = [ "@sp" ];
          };

          youtube = {
            name = "Youtube";
            urls = [
              {
                template = "https://www.youtube.com/results?search_query={searchTerms}";
              }
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/f/fd/YouTube_full-color_icon_%282024%29.svg";
            definedAliases = [ "@yt" ];
          };

          nixPackages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }
            ];
            icon = nixIcon;
            definedAliases = [ "@np" ];
          };

          nixOptions = {
            name = "Nix Options";
            urls = [
              {
                template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              }
            ];
            icon = nixIcon;
            definedAliases = [ "@no" ];
          };

          nixHydra = {
            name = "Nix Hydra";
            urls = [
              {
                template = "https://hydra.nixos.org/search?query={searchTerms}";
              }
            ];
            icon = nixIcon;
            definedAliases = [ "@nh" ];
          };

          homeManagerOptions = {
            name = "Nix Home Manager Options";
            urls = [
              {
                template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
              }
            ];
            icon = nixIcon;
            definedAliases = [ "@hm" ];
          };

          stylixDocs = {
            name = "Stylix Docs";
            urls = [
              {
                template = "https://nix-community.github.io/stylix?search={searchTerms}";
              }
            ];
            icon = nixIcon;
            definedAliases = [ "@stylix" ];
          };

          githubCode = {
            name = "Github Code";
            urls = [
              {
                template = "https://github.com/search?type=code&q={searchTerms}";
              }
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg";
            definedAliases = [ "@gh" ];
          };

          githubRepositories = {
            name = "Github Repositories";
            urls = [
              {
                template = "https://github.com/search?type=repositories&q={searchTerms}";
              }
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg";
            definedAliases = [ "@ghr" ];
          };

          reddit = {
            name = "Reddit";
            urls = [
              {
                template = "https://old.reddit.com/search?q={searchTerms}";
              }
            ];
            icon = "https://upload.wikimedia.org/wikipedia/en/b/bd/Reddit_Logo_Icon.svg";
            definedAliases = [ "@r" ];
          };

          perplexity = {
            name = "Perplexity";
            urls = [
              {
                template = "https://www.perplexity.ai/search?q={searchTerms}";
              }
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/b/b5/Perplexity_AI_Turquoise_on_White.png";
            definedAliases = [ "@pe" ];
          };
        };
      };
    };
  };

  xdg.mimeApps =
    let
      value =
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight.meta.desktopFileName;

      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name value;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
}

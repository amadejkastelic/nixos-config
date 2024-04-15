{
  pkgs,
  config,
  ...
}: {
  programs.zathura = {
    enable = true;
    options = {
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";

      font = "Inter 12";
      selection-notification = true;

      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      zoom-min = "10";
    };

    extraConfig =
      "include catppuccin-"
      + (
        if config.theme.name == "light"
        then "latte"
        else "mocha"
      );
  };

  xdg.configFile = {
    "zathura/catppuccin-latte".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-latte";
      hash = "sha256-KuJ4KG5vWP8v4J4eUQfW++XAriSVh15t0rwz9/xPZbk=";
    };
    "zathura/catppuccin-mocha".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-mocha";
      hash = "sha256-QZypNMfVlTzMRaQ286DDWL9dAvQZ8INkllzo8t0aHf4=";
    };
  };
}

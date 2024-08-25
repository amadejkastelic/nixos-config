{
  programs.nixcord = {
    enable = true;

    discord.enable = false;
    vesktop.enable = true;

    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha.theme.css"
      ];
      enabledThemes = [
        "Catppuccin Mocha"
      ];

      plugins = {
        crashHandler = {
          enable = true;
          attemptToPreventCrashes = true;
        };
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}

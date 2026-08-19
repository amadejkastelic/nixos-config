{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;

    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha.theme.css"
      ];
      enabledThemes = [
        "Catppuccin Mocha"
      ];
      frameless = true;

      plugins = {
        crashHandler = {
          enable = true;
          attemptToPreventCrashes = true;
        };
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        silentTyping.enable = true;
        messageLogger.enable = true;
      };
    };
  };
}

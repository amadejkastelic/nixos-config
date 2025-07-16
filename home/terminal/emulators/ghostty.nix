{
  programs.ghostty = {
    enable = true;

    enableZshIntegration = true;

    clearDefaultKeybinds = false;

    settings = {
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 12;

      background-opacity = "0.9";

      window-decoration = false;
      gtk-titlebar = false;

      cursor-style = "bar";
    };
  };

  catppuccin.ghostty.enable = true;
}

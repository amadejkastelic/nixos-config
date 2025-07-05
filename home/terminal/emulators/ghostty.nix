{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;

    package = pkgs.ghostty.overrideAttrs (_: {
      preBuild = ''
        shopt -s globstar
        sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        shopt -u globstar
      '';
    });

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

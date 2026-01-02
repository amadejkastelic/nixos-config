{
  pkgs,
  inputs,
  ...
}:
let
  fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
  emojiPkg = inputs.apple-emoji.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;

    image = ./wallpaper.jpeg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      serif = {
        package = fonts.sf-pro-nerd;
        name = "SFProText Nerd Font";
      };

      sansSerif = {
        package = fonts.sf-pro-nerd;
        name = "SFProText Nerd Font";
      };

      monospace = {
        package = fonts.sf-mono-nerd;
        name = "SFMono Nerd Font";
      };

      emoji = {
        package = emojiPkg;
        name = "Apple Color Emoji";
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 9;
        terminal = 12;
      };
    };

    cursor = {
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-cursors-svg;
      name = "Bibata-Modern-Ice-Hyprcursor";
      size = 24;
    };

    opacity = {
      applications = 0.93;
      terminal = 0.93;
    };
  };
}

{
  pkgs,
  config,
  ...
}: rec {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  catppuccin.cursors.enable = false;

  gtk = {
    enable = true;

    font = {
      name = "Inter";
      package = pkgs.google-fonts.override {fonts = ["Inter"];};
      size = 10;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "standard";
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "pink";
      };
    };
  };

  xdg.configFile = let
    g = gtk.theme.package;
  in {
    "gtk-4.0/assets".source = "${g}/share/themes/${g}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${g}/share/themes/${g}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${g}/share/themes/${g}/gtk-4.0/gtk-dark.css";
  };
}

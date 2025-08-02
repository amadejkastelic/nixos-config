{
  pkgs,
  config,
  ...
}:
{
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
      package = pkgs.google-fonts.override { fonts = [ "Inter" ]; };
      size = 10;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    theme = {
      name = "Catppuccin-GTK-Pink-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "pink" ];
        shade = "dark";
        size = "standard";
        tweaks = [ "macos" ];
      };
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  dconf = {
    enable = true;
    settings = {
      # hide X button
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
    };
  };
}

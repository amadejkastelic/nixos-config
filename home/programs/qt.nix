{
  pkgs,
  lib,
  ...
}:
{
  stylix.targets.qt.enable = false;

  qt = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    platformTheme.name = "qtct";
    style.package = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];

    kvantum = {
      enable = true;
      themes = [
        (pkgs.catppuccin-kvantum.override {
          variant = "mocha";
          accent = "mauve";
        })
      ];
      settings.General.theme = "catppuccin-mocha-mauve";
    };

    qt5ctSettings.Appearance = {
      style = "kvantum";
      icon_theme = "Papirus-Dark";
      standard_dialogs = "default";
    };
    qt6ctSettings.Appearance = {
      style = "kvantum";
      icon_theme = "Papirus-Dark";
      standard_dialogs = "default";
    };
  };
}

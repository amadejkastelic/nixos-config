{
  lib,
  config,
  ...
}:
let
  qtctConf = {
    Appearance = {
      custom_palette = false;
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum";
    };
  };

  defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";
in
{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  catppuccin.kvantum = {
    enable = true;
    accent = "pink";
    flavor = "mocha";
  };

  xdg.configFile = {
    "qt5ct/qt5ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );

    "qt6ct/qt6ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );
  };
}

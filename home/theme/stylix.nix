{ pkgs, ... }:
{
  stylix = {
    enable = true;

    autoEnable = true;

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    targets = {
      nixcord.enable = false;
      mangohud.enable = false;
      hyprlock.enable = false;
      zen-browser.profileNames = [ "default" ];
    };
  };
}

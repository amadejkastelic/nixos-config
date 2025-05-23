{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;

    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment.systemPackages = [ pkgs.xarchiver ];

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}

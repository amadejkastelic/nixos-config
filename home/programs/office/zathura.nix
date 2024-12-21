{
  pkgs,
  config,
  ...
}: {
  programs.zathura = {
    enable = true;
  };

  catppuccin.zathura.enable = true;
}

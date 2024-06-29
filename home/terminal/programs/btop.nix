{
  pkgs,
  config,
  ...
}: let
  variant =
    if config.theme.name == "light"
    then "latte"
    else "mocha";
in {
  programs.btop = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = variant;
    };
  };
}

{
  config,
  pkgs,
  ...
}: let
  variant =
    if config.theme.name == "light"
    then "latte"
    else "mocha";
in {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}

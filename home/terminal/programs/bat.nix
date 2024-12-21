{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  catppuccin.bat.enable = true;

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}

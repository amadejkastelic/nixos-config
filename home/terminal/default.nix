{ config, ... }:
let
  data = config.xdg.dataHome;
  conf = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in
{
  imports = [
    ./programs
    ./shell/starship.nix
    ./shell/zsh.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = "${cache}/less/history";
    LESSKEY = "${conf}/less/lesskey";

    WINEPREFIX = "${data}/wine";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";

    GITHUB_TOKEN = "$(cat ${config.sops.secrets.github-token.path})";

    # auto-run programs using nix-index-database
    NIX_AUTO_RUN = "1";
  };

  sops.secrets.github-token = { };
}

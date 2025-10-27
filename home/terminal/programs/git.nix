{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.gh ];

  # enable scrolling in git diff
  home.sessionVariables.DELTA_PAGER = "less -R";

  catppuccin.delta.enable = true;

  programs.delta.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "amadejkastelic7@gmail.com";
        name = "Amadej Kastelic";
      };

      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";

      gpg = {
        ssh.defaultKeyCommand = "sh -c 'echo key::$(ssh-add -L | head -1)'";
        commit.gpgsign = true;
      };

      aliases = {
        a = "add";
        b = "branch";
        c = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        co = "checkout";
        d = "diff";
        ds = "diff --staged";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        l = "log";
        r = "rebase";
        s = "status --short";
        ss = "status";
        forgor = "commit --amend --no-edit";
        graph = "log --all --decorate --graph --oneline";
        oops = "checkout --";
      };
    };

    ignores = [
      "*~"
      "*.swp"
      "*result*"
      ".direnv"
      "node_modules"
    ];

    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };
  };
}

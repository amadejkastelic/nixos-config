{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = false;
      term = "kitty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";
      columns = 2;
      allow_images = true;
      no_actions = true;
    };

    style = ''
      @import url("https://raw.githubusercontent.com/quantumfate/wofi/main/src/mocha/style.css");
    '';
  };

  home.packages = with pkgs; [
    wofi-emoji
  ];
}

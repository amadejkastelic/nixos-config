{
  programs.kitty = {
    enable = true;

    settings = {
      scrollback_lines = 10000;
      placement_strategy = "center";

      allow_remote_control = "yes";
      enable_audio_bell = "no";

      copy_on_select = "clipboard";

      selection_foreground = "none";
      selection_background = "none";
    };
  };
}

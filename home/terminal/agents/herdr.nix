{
  programs.herdr = {
    enable = true;

    settings = {
      onboarding = false;
      terminal.default_shell = "zsh";
      theme.name = "catppuccin";

      ui = {
        agent_panel_sort = "priority";
        hide_tab_bar_when_single_tab = true;
        prompt_new_tab_name = false;
        toast.delivery = "system";
      };

      update.version_check = false;
    };
  };
}

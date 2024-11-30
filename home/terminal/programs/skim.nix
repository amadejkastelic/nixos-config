{
  programs.skim = {
    enable = true;
    enableZshIntegration = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    defaultCommand = "rg --files --hidden";

    changeDirWidgetOptions = [
      "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
      "--exact"
    ];
  };
}

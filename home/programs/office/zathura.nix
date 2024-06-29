{
  pkgs,
  config,
  ...
}: {
  programs.zathura = {
    enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
}

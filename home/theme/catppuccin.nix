{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = false;
    accent = "mauve";
    flavor = "mocha";
  };
}

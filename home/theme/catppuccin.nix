{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = false;
    accent = "pink";
    flavor = "mocha";
  };
}

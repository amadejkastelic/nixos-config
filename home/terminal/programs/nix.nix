{
  pkgs,
  self,
  ...
}:
# nix tooling
{
  home.packages = with pkgs; [
    nil
    nixfmt
    deadnix
    statix
    self.packages.${pkgs.stdenv.hostPlatform.system}.repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    silent = true;
  };
}

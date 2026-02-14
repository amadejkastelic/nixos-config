{
  pkgs,
  self,
  ...
}:
# nix tooling
{
  home.packages = with pkgs; [
    nixd
    nixfmt
    deadnix
    statix
    self.packages.${pkgs.stdenv.hostPlatform.system}.repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    silent = true;
  };
}

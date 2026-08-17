{ config, pkgs, ... }:
{
  programs.atuin = {
    enable = true;
    daemon.enable = !pkgs.stdenv.hostPlatform.isDarwin;

    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };
}

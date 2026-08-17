{ pkgs, lib, ... }:
{
  programs.zathura = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    enable = true;
  };
}

{ pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ pkgs.mpvScripts.mpris ];
  };
}

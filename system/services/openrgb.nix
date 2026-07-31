{ pkgs, ... }:
{
  services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;
}

{ pkgs, inputs, ... }:
{
  services.hardware.openrgb.package =
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.openrgb-rc;
}

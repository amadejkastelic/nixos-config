{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-cursors-svg
  ];

  environment.pathsToLink = [ "/share/icons" ];

  programs.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    withUWSM = true;
  };

  services.seatd.enable = true;
}

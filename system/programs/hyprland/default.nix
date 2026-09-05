{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bibata-cursors-svg
  ];

  environment.pathsToLink = [ "/share/icons" ];

  programs.hyprland = {
    enable = true;

    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    withUWSM = true;
  };

  services.seatd.enable = true;
}

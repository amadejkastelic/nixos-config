{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  environment.systemPackages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  environment.pathsToLink = ["/share/icons"];

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
  };

  services.seatd.enable = true;

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";
}

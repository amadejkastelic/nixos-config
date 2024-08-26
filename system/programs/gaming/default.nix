{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./gamemode.nix
    ./gamescope.nix
  ];

  environment.systemPackages = with pkgs; [
    mangohud
  ];

  services.power-profiles-daemon.enable = true;
}

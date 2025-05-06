{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
  ];

  services.scx = {
    enable = true;
    package = pkgs.scx.full;
    scheduler = "scx_lavd";
  };

  environment.systemPackages = with pkgs; [
    pcscliteWithPolkit
  ];

  hardware = {
    opentabletdriver.enable = true;
  };

  networking.hostName = "ryzen";

  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
  };
}

{
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./idescriptor.nix
    ./noisetorch.nix
    ./obs.nix
    ./xdg.nix
  ];

  environment.systemPackages = [
    pkgs.kdePackages.partitionmanager
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.kio-extras
    pkgs.kdePackages.kio-admin
    pkgs.kdePackages.plasma-systemmonitor
    pkgs.kdePackages.ksystemstats
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = false;
  };
}

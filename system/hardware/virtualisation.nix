{
  imports = [
    ./docker.nix
    ./../../lib/vfio.nix
    ./../../lib/virtualisation.nix
  ];

  virtualisation = {
    waydroid.enable = false;

    vfio = {
      enable = false;
      IOMMUType = "amd";
      devices = [
        "1002:67df"
        "1002:aaf0"
      ];
      disableEFIfb = false;
    };

    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;
}

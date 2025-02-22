{pkgs, ...}: {
  imports = [
    ./../../lib/vfio.nix
    ./../../lib/virtualisation.nix
  ];

  virtualisation = {
    vfio = {
      enable = false;
      IOMMUType = "amd";
      devices = [
        "1002:67df"
        "1002:aaf0"
      ];
      disableEFIfb = false;
    };

    docker.rootless = {
      enable = true;
      package = pkgs.docker;
      setSocketVariable = true;
    };

    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;
}

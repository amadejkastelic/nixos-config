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
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };

    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;
}

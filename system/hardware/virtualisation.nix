{
  pkgs,
  config,
  ...
}: {
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
      setSocketVariable = true;
    };
  };
}

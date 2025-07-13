{
  config,
  self,
  inputs,
  ...
}:
{
  imports = [
    ./specialisations.nix
    ./terminal
    ./theme
    inputs.matugen.nixosModules.default
    inputs.nix-index-db.homeModules.nix-index
    inputs.sops-nix.homeManagerModules.sops
    self.nixosModules.theme
  ];

  home = {
    username = "amadejk";
    homeDirectory = "/home/amadejk";
    stateVersion = "23.11";
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];
  };

  sops = {
    age.sshKeyPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
    defaultSopsFile = ./secrets.yaml;
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}

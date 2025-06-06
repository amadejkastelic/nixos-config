{
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
    inputs.nix-index-db.hmModules.nix-index
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

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}

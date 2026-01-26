{ pkgs, self, ... }:
{
  programs.idescriptor = {
    enable = true;

    package = self.packages.${pkgs.stdenv.hostPlatform.system}.idescriptor;

    users = [ "amadejk" ];
  };
}

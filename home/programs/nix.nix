{ config, ... }:
{
  nix.extraOptions = ''
    # Include the SOPS file for Nix access tokens
    !include ${config.sops.secrets.nix-access-tokens.path}
  '';

  sops.secrets.nix-access-tokens = { };
}

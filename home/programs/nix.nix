{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets.nix-access-tokens = { };

  xdg.configFile."nix/nix.conf" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    text = ''
      !include ${config.sops.secrets.nix-access-tokens.path}
    '';
  };

  nix.extraOptions = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) ''
    !include ${config.sops.secrets.nix-access-tokens.path}
  '';
}

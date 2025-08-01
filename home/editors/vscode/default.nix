{ pkgs, ... }:
{
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./settings.nix
    ./server.nix
  ];

  programs.vscode = {
    enable = true;
    # Pylance doesn't work in vscodium
    # https://github.com/VSCodium/vscodium/discussions/1641
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

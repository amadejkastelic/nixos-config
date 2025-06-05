{ pkgs, ... }:
{
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./settings.nix
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

  services.vscode-server = {
    enable = true;
    enableFHS = false;
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

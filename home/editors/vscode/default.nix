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

    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };

  catppuccin.vscode.profiles.default.enable = true;

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

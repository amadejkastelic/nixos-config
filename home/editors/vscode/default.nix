{pkgs, ...}: {
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./settings.nix
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

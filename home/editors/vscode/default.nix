{pkgs, ...}: {
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./settings.nix
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

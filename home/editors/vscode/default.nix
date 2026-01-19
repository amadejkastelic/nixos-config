{
  pkgs,
  inputs,
  ...
}:
let
  mkNixpkgsUnfree =
    system:
    import inputs.nixpkgs-vscode {
      inherit system;
      config.allowUnfree = true;
    };
in
{
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./settings.nix
    ./server.nix
  ];

  programs.vscode = {
    enable = true;

    # https://github.com/microsoft/vscode/issues/260391
    package = (mkNixpkgsUnfree pkgs.stdenv.hostPlatform.system).vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };

  catppuccin.vscode.profiles.default.enable = true;

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}

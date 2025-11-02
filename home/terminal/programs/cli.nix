{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify

    # utils
    dust
    duf
    fd
    file
    jaq
    ripgrep
  ];

  programs = {
    eza.enable = true;
    ssh = {
      enable = true;

      matchBlocks."github.com" = {
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
}

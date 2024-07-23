{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./gamemode.nix
    ./gamescope.nix
  ];

  environment.systemPackages = with pkgs; [
    mangohud
  ];

  /*
    nixpkgs.overlays = [
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (old: {
        version = "3.14.24";
        src = prev.fetchFromGitHub {
          owner = "ChimeraOS";
          repo = "gamescope";
          rev = "refs/tags/3.14.24-plus1";
          fetchSubmodules = true;
          hash = "sha256-Ym1kl9naAm1MGlxCk32ssvfiOlstHiZPy7Ga8EZegus=";
        };
      });
    })
  ];
  */
}

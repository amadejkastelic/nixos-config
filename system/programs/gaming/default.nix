{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./gamemode.nix
  ];

  environment.systemPackages = with pkgs; [
    mangohud
    bottles
    gamescope
  ];

  # Downgrade gamescope
  nixpkgs.overlays = [
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (old: {
        version = "3.14.2";
        src = prev.fetchFromGitHub {
          owner = "ValveSoftware";
          repo = "gamescope";
          rev = "refs/tags/3.14.2";
          fetchSubmodules = true;
          hash = "sha256-Ym1kl9naAm1MGlxCk32ssvfiOlstHiZPy7Ga8EZegus=";
        };
      });
    })
  ];
}

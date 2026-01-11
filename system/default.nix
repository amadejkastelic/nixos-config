{ self, ... }:
let
  common = [
    self.modules.services

    ./core/default.nix

    ./network/default.nix
    ./network/tailscale.nix
  ];

  desktop = common ++ [
    ./core/boot.nix
    ./core/lanzaboote.nix

    ./network/avahi.nix
    ./hardware/bluetooth.nix
    ./hardware/input.nix
    ./hardware/ledger.nix
    ./hardware/opengl.nix

    ./programs

    ./services
    ./services/clipboard-sync.nix
    ./services/greetd.nix
    ./services/ollama.nix
    ./services/openrgb.nix
    ./services/pipewire.nix
    ./services/gpg.nix
    ./services/printing.nix

    ./theme/stylix.nix
  ];

  server = common ++ [
    ./hardware/docker.nix

    ./services/arr
    ./services/blocky.nix
    ./services/dashboard.nix
    ./services/grabby.nix
    ./services/jellyfin.nix
    ./services/metrics
    ./services/nginx.nix
  ];
in
{
  inherit desktop server;
}

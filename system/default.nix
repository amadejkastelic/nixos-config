{ self, ... }:
let
  common = [
    self.modules.services

    ./core/default.nix

    ./network/avahi.nix
    ./network/default.nix
    ./network/nfs.nix
    ./network/tailscale.nix
  ];

  desktop = common ++ [
    ./core/boot.nix
    ./core/lanzaboote.nix

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

  nas = common ++ [
    ./programs/msmtp.nix

    ./services/nas
  ];

  server = common ++ [
    ./hardware/docker.nix

    ./programs/msmtp.nix

    ./services/arr
    ./services/blocky.nix
    ./services/dashboard.nix
    ./services/flaresolverr.nix
    ./services/grabby.nix
    ./services/jellyfin.nix
    ./services/metrics
    ./services/nginx.nix
    ./services/vaultwarden.nix
  ];
in
{
  inherit desktop server nas;
}

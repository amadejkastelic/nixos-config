let
  common = [
    ./core/default.nix

    ./network/default.nix
    ./network/tailscale.nix
  ];

  desktop = common ++ [
    ./core/boot.nix
    ./core/lanzaboote.nix

    ./hardware/opengl.nix

    ./network/avahi.nix

    ./programs

    ./hardware/bluetooth.nix
    ./hardware/input.nix
    ./hardware/ledger.nix

    ./services
    ./services/clipboard-sync.nix
    ./services/greetd.nix
    ./services/ollama.nix
    ./services/pipewire.nix
    ./services/gpg.nix
    ./services/printing.nix
  ];

  server = common ++ [
    ./hardware/docker.nix

    ./services/discord-bot.nix
  ];
in
{
  inherit desktop server;
}

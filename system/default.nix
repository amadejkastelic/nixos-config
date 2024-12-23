let
  desktop = [
    ./core/boot.nix
    ./core/lanzaboote.nix
    ./core/default.nix

    ./hardware/opengl.nix

    ./network/avahi.nix
    ./network/default.nix

    ./programs

    ./hardware/bluetooth.nix
    ./hardware/controller.nix
    ./hardware/ledger.nix

    ./services
    ./services/clipboard-sync.nix
    ./services/greetd.nix
    ./services/ollama.nix
    ./services/pipewire.nix
    ./services/gpg.nix
    ./services/printing.nix
  ];

  laptop =
    desktop
    ++ [
      ./services/backlight.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}

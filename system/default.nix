let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix

    ./network/avahi.nix
    ./network/default.nix

    ./programs

    ./hardware/bluetooth.nix

    ./services
    ./services/greetd.nix
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
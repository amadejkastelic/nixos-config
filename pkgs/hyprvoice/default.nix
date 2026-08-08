{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pipewire,
  wl-clipboard,
  wtype,
  ydotool,
  libnotify,
  whisper-cpp-vulkan,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hyprvoice";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "LeonardoTrapani";
    repo = "hyprvoice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ng17y53L9cyxSjupSGKyZkBXOGneJrjprjvODYch6EE=";
  };

  vendorHash = "sha256-b1IsFlhj+xTQT/4PzL97YjVjjS7TQtcIsbeK3dLOxR4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/hyprvoice \
      --prefix PATH : ${
        lib.makeBinPath [
          pipewire
          wl-clipboard
          wtype
          ydotool
          libnotify
          whisper-cpp-vulkan
        ]
      }
  '';

  nativeCheckInputs = [
    wl-clipboard
    wtype
    ydotool
  ];

  checkFlags = [
    # Tests require a running wayland compositor and pipewire
    "-skip=TestInjector|TestRecorder"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version-regex"
      "^v(.*)$"
    ];
  };

  meta = {
    description = "Voice-powered typing for Hyprland/Wayland";
    longDescription = ''
      Press a toggle key, speak, and get instant text input.
      Built natively for Wayland/Hyprland - no X11 hacks or workarounds,
      just clean integration with modern Linux desktops.
    '';
    homepage = "https://github.com/LeonardoTrapani/hyprvoice";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hyprvoice";
    maintainers = with lib.maintainers; [ amadejkastelic ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sekirofpsunlock";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Lahvuun";
    repo = "sekirofpsunlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tdKm7VNlOQST2uIXTajD7BCbhLktNRysOuDSYd9ONEU=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 sekirofpsunlock -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version-regex"
      "^v(.*)$"
    ];
  };

  meta = {
    description = "Linux patcher for Sekiro that removes FPS and resolution limitations";
    homepage = "https://github.com/Lahvuun/sekirofpsunlock";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "sekirofpsunlock";
  };
})

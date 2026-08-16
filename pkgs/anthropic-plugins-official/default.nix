{
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-plugins-official";
  version = "0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "2dc97c0d12ab25539cf5f85294c068511269ab09";
    hash = "sha256-ugVA1B4R+n9AyxIZQ22JsuyVRjHd2oQHZsAPW0M5OVk=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    cp -r . $out
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta.description = "Anthropic's official Claude plugin marketplace repository";
})

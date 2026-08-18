{
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anthropic-skills";
  version = "0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "f379e5ad66e2febc1616cf8d6284666fecbe514e";
    hash = "sha256-BDLEsQ4rJLspINlHpu0rkvaC4BHdwQ4QUTko/v+xbAE=";
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

  meta.description = "Anthropic's official Claude skills repository";
})

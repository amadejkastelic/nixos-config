{
  lib,
  fetchFromGitHub,
  python3,
  nix-update-script,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "ib_edavki";
  version = "0-unstable-2026-03-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jamsix";
    repo = "ib-edavki";
    rev = "22220f546378b638c129ffe4bd6f2c9a3139809c";
    hash = "sha256-W0SBIC2UWnutCHgx3l1xh/ATa+KwDWJNR8tm9PDtYDk=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    requests
    certifi
  ];

  pythonImportsCheck = [ "ib_edavki" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Convert InteractiveBrokers XML reports to Slovenian tax forms (Doh-KDVP, D-IFI, D-Div, Doh-Obr)";
    homepage = "https://github.com/jamsix/ib-edavki";
    mainProgram = "ib_edavki";
    license = lib.licenses.mit;
  };
})

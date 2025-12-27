{ lib, pkgs, ... }:
let
  quickshell = pkgs.quickshell;
  defaultConfig = "default";
in
{
  home.sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
  ];

  programs.quickshell = {
    enable = true;
    package = quickshell;

    activeConfig = defaultConfig;
    configs = {
      ${defaultConfig} = ../.;
    };
  };
}

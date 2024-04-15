{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  services.mako = {
    enable = true;

    anchor = "top-center";
    defaultTimeout = 3000;

    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#f5c2e7";
    progressColor = "over #313244";
    extraConfig = ''
      [urgency=high]
      border-color=#fab387
    '';
    borderRadius = 16;
  };
}

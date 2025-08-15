{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [
      "gpt-oss:20b"
      "vanilj/supernova-medius:iq2_m"
    ];
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };

  # Fix amdgpu race condition
  # https://github.com/NixOS/nixpkgs/pull/422355
  systemd.services.ollama.after = [ "systemd-modules-load.service" ];

  nixpkgs.config.rocmSupport = true;

  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3000;
    ollamaUrl = "http://127.0.0.1:${toString config.services.ollama.port}";
  };
}

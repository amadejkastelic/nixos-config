{ config, pkgs, ... }:
{
  services.ollama = {
    enable = false;
    package = pkgs.ollama-rocm;
    loadModels = [
      "gpt-oss:20b"
      "vanilj/supernova-medius:iq2_m"
    ];
    rocmOverrideGfx = "10.3.0";
  };

  nixpkgs.config.rocmSupport = true;

  services.nextjs-ollama-llm-ui = {
    enable = false;
    port = 3000;
    ollamaUrl = "http://127.0.0.1:${toString config.services.ollama.port}";
  };
}

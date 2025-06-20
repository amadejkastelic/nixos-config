{ pkgs, ... }:
let
  port = 11434;
in
{
  services.ollama = {
    enable = false;
    package = pkgs.ollama-rocm;
    port = port;
    loadModels = [
      "deepseek-r1:14b"
      "vanilj/supernova-medius:iq2_m"
    ];
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };

  nixpkgs.config.rocmSupport = true;

  services.nextjs-ollama-llm-ui = {
    enable = false;
    port = 3000;
    ollamaUrl = "http://127.0.0.1:${toString port}";
  };
}

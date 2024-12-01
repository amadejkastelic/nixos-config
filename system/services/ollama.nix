{pkgs, ...}: let
  port = 11434;
in {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    port = port;
    loadModels = ["llama3.2" "qwen2.5-coder:3b"];
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };

  nixpkgs.config.rocmSupport = true;

  services.nextjs-ollama-llm-ui = {
    enable = true;
    port = 3000;
    ollamaUrl = "http://127.0.0.1:${toString port}";
  };
}

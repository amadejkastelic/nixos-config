{pkgs, ...}: let
  port = 11434;
in {
  # https://github.com/NixOS/nixpkgs/issues/368672
  services.ollama = {
    enable = false;
    package = pkgs.ollama-rocm;
    port = port;
    loadModels = ["llama3.2" "qwen2.5-coder:3b"];
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };

  nixpkgs.config.rocmSupport = false;

  services.nextjs-ollama-llm-ui = {
    enable = false;
    port = 3000;
    ollamaUrl = "http://127.0.0.1:${toString port}";
  };
}

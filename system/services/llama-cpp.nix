{
  services.llama-cpp-server = {
    enable = true;
    rocmOverrideGfx = "10.3.0";

    models."qwen2.5-coder" = {
      hfRepo = "Qwen/Qwen2.5-Coder-7B-Instruct-GGUF";
      hfFile = "qwen2.5-coder-7b-instruct-q4_k_m.gguf";
      port = 11434;
      ctxSize = 32768;
      nGpuLayers = 99;
      extraArgs = [
        "-fa"
        "0"
      ];
    };
  };
}

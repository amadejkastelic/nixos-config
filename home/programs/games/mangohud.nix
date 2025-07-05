{
  programs.mangohud = {
    enable = true;
    settings = {
      full = false;
      cpu_temp = true;
      gpu_temp = true;
      vram = false;
      frame_timing = false;
      toggle_hud = "Shift_L+F11";
      position = "top-right";
    };
  };

  catppuccin.mangohud.enable = false;
}

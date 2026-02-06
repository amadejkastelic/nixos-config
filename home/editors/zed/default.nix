{ lib, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;

    extensions = [
      "nix"
      "material-icon-theme"
      "opencode"
      "zig"
    ];

    userSettings = {
      vim_mode = false;
      format_on_save = "on";

      autosave.after_delay.milliseconds = 1000;

      icon_theme = "Material Icon Theme";

      ui_font_size = 16;
      buffer_font_size = 18;

      terminal = {
        font_size = 16;
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      language_models = {
        openai = {
          api_url = "http://127.0.0.1:11434";
          available_models = [
            {
              name = "qwen2.5-coder";
              display_name = "qwen2.5-coder";
              max_tokens = 128000;
            }
          ];
        };
      };
    };

    extraPackages = with pkgs; [
      nil
      nixd
      nixfmt

      # These two are needed because nushell depends on them
      starship
      carapace
    ];
  };

  catppuccin.zed = {
    enable = true;
    icons.enable = false;
    italics = false;
  };
}

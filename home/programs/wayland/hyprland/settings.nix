{config, ...}: let
  variant = config.theme.name;
  c = config.programs.matugen.theme.colors.colors_android.${variant};
  pointer = config.home.pointerCursor;
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    env = [
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "WLR_DRM_NO_ATOMIC,1"
    ];

    exec-once = [
      "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
      "hyprlock"
      "waybar"
      "wl-paste --watch cliphist store"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 16;
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.02;
        ignore_opacity = true;

        passes = 3;
        size = 10;
      };

      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "0 2";
      shadow_range = 20;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    group = {
      groupbar = {
        font_size = 16;
        gradients = false;
      };

      "col.border_active" = "rgba(${c.color_accent_primary}88);";
      "col.border_inactive" = "rgba(${c.color_accent_primary_variant}88)";
    };

    input = {
      kb_layout = "si";

      # focus change on cursor move
      follow_mouse = 1;
      force_no_accel = true;

      touchdevice = {
        enabled = false;
      };
    };

    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;

      force_default_wallpaper = 0;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      vrr = 0;
      no_direct_scanout = false;
      render_ahead_of_time = false;
    };

    xwayland = {
      force_zero_scaling = true;
      use_nearest_neighbor = false;
    };

    debug.disable_logs = true;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    plugin {
      csgo-vulkan-fix {
        #res_w = 1280
        #res_h = 960
        res_w = 2560
        res_h = 1440
        class = cs2
      }
    }
  '';
}

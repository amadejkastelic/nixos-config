let
  screenshotarea = ''shader=$(hyprshade current) && hyprshade off && grimblast --freeze --notify copy area; hyprshade on "$shader"'';
  #screenshotarea = ''grimblast --freeze --notify copy area'';

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 10
  );
  toggle =
    program:
    let
      prog = builtins.substring 0 14 program;
    in
    "pkill ${prog} || uwsm app -- ${program}";

  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
in
{
  programs.hyprland.settings = {
    # mouse movements
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # binds
    bind =
      let
        monocle = "dwindle:no_gaps_when_only";
      in
      [
        # compositor commands
        # "$mod SHIFT, E, exec, pkill Hyprland"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        # "$mod, G, togglegroup,"
        "$mod SHIFT, N, changegroupactive, f"
        "$mod SHIFT, P, changegroupactive, b"
        # "$mod, R, togglesplit,"
        "$mod, W, togglefloating,"
        "$mod, P, pseudo,"
        "$mod ALT, ,resizeactive,"

        # toggle "monocle" (no_gaps_when_only)
        "$mod, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

        # Gaming workspace
        "$mod, G, workspace, name:Gaming"
        "$mod SHIFT, G, movetoworkspace, name:Gaming"

        # utility
        # terminal
        "$mod, T, exec, ghostty"
        # logout menu
        "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell -b 2"
        # lock screen
        "$mod, L, exec, ${runOnce "hyprlock"}"
        # select area to perform OCR on
        "$mod, O, exec, uwsm app -- wl-ocr"
        # Emoji picker
        "$mod, E, exec, pkill rofi || rofimoji -a clipboard -s light -r 🔍"
        # Clipboard manager
        "$mod, V, exec, pkill rofi || rofi -p '🔍' -modi clipboard:rofi-cliphist -show clipboard -show-icons"
        # File manager
        "$mod, N, exec, nautilus"

        # move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Launcher
        "$mod, R, exec, ${toggle "anyrun"}"

        # screenshot
        # stop animations while screenshotting; makes black border go away
        ", Print, exec, ${screenshotarea}"
        "$mod SHIFT, R, exec, ${screenshotarea}"

        "CTRL, Print, exec, grimblast --notify --cursor copysave output"
        "$mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output"

        "ALT, Print, exec, grimblast --notify --cursor copysave screen"
        "$mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen"
      ]
      ++ workspaces;

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    bindle = [
      # volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"
    ];
  };
}

{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # layer rules
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      ignorealpha = [
        # ags
        "calendar"
        "notifications"
        "osd"
        "system-menu"

        "anyrun"
      ];

      layers = ignorealpha ++ ["bar" "gtk-layer-shell"];
    in [
      "blur, ${toRegex layers}"
      "xray 1, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.2, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.5, ${toRegex (ignorealpha ++ ["music"])}"
    ];

    # window rules
    windowrulev2 = [
      # float
      "float, title:^(Media viewer)$"
      "float, class:^(pavucontrol)$"
      "float, class:^(nm-connection-editor)$"
      "float, title:^(Spotify( Premium)?)$"
      "float, class:^(vesktop)$"

      # Dialogs
      "float, title:^(Open File)$"
      "opacity 0.80 0.70, title:^(Open File)$"
      "size 1280 720, title:^(Open File)$"

      # opacity
      "opacity 0.80 0.70, class:^(pavucontrol)$"
      "opacity 0.80 0.70, class:^(nm-connection-editor)$"
      "opacity 0.80 0.70, class:^(vesktop)$"
      "opacity 0.80 0.70, title:^(Spotify( Premium)?)$"

      # allow tearing in games
      "immediate, class:.*"

      # Games
      "workspace name:Gaming, class:gamescope"
      "workspace name:Gaming, class:cs2"

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # Spotify
      "workspace 9 silent, title:^(Spotify( Premium)?)$"
      "center, title:^(Spotify( Premium)?)$"
      "size 1920 1080, title:^(Spotify( Premium)?)$"

      # Discord
      "workspace 8 silent, class:^(vesktop)$"
      "center, class:^(vesktop)$"
      "size 1920 1080, class:^(vesktop)$"

      # Steam
      "workspace 10 silent, class:^(steam)"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # fix xwayland apps
      # "rounding 0, xwayland:1"
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
    ];
  };
}

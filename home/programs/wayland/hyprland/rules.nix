{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # layer rules
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      ignorealpha = [
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
      "float, initialClass:^(org.pulseaudio.pavucontrol)$"
      "float, initialClass:^(org.gnome.Nautilus)$"

      # opacity
      "opacity 0.80 0.70, initialClass:^(org.pulseaudio.pavucontrol)$"
      "opacity 0.80 0.70, initialClass:^(org.pulseaudio.Nautilus)$"
      "opacity 0.80 0.70, class:^(nm-connection-editor)$"
      "opacity 0.80 0.70, class:^(vesktop)$"
      "opacity 0.80 0.70, title:^(Spotify( Premium)?)$"

      # make Firefox / Zen PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(Zen — Sharing Indicator)$"
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

      # Games
      "workspace name:Gaming, class:gamescope"
      "workspace name:Gaming, initialclass:cs2"
      "workspace name:Gaming, initialclass:^(steam_app_)(.*)"
      #"immediate, initialclass:^(steam_app_\d+|SDL Application)$"
      "immediate, initialclass:^(steam_app_)(.*)$"
      "fullscreen, initialclass:^(steam_app_)(.*)$"
      "fullscreen, initialclass:cs2"
      "renderunfocused, initialclass:^(steam_app_)(.*)^(steam_app_\d+|cs2)$"
      "float, initialtitle:Hearthstone"
      "size 1920 1080, initialtitle:Hearthstone"
      "maxsize 1920 1080, initialtitle:Hearthstone"
      "minsize 1920 1080, initialtitle:Hearthstone"
      "center, initialtitle:Hearthstone"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "float, class:^(xdg-desktop-portal-gtk)$"
      "center, class:^(xdg-desktop-portal-gtk)$"
      "size 1920 1080, class:^(xdg-desktop-portal-gtk)$"
      "size 1920 1080, initialClass:^(org.gnome.Nautilus)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # fix xwayland apps
      # "rounding 0, xwayland:1"
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
    ];
  };
}

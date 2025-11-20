{ lib, ... }:
{
  programs.hyprland.settings = {
    # layer rules
    layerrule =
      let
        toRegex =
          list:
          let
            elements = lib.concatStringsSep "|" list;
          in
          "^(${elements})$";

        ignorealpha = [
          "calendar"
          "notifications"
          "osd"
          "system-menu"
          "anyrun"
        ];

        layers = ignorealpha ++ [
          "bar"
          "gtk-layer-shell"
        ];
      in
      [
        "blur, ${toRegex layers}"
        "xray 1, ${
          toRegex [
            "bar"
            "gtk-layer-shell"
          ]
        }"
        "ignorealpha 0.2, ${
          toRegex [
            "bar"
            "gtk-layer-shell"
          ]
        }"
        "ignorealpha 0.5, ${toRegex (ignorealpha ++ [ "music" ])}"
      ];

    # window rules
    windowrule = [
      # float
      "float, title:^(Media viewer)$"
      "float, class:^(pavucontrol)$"
      "float, class:^(nm-connection-editor)$"
      "float, title:^(Spotify( Premium)?)$"
      "float, class:^(vesktop)$"
      "float, initialClass:^(org.pulseaudio.pavucontrol)$"
      "float, initialClass:^(org.gnome.Nautilus)$"
      "float, initialClass:^(Cider)$"

      # opacity
      "opacity 0.80 0.70, initialClass:^(org.pulseaudio.pavucontrol)$"
      "opacity 0.80 0.70, initialClass:^(org.pulseaudio.Nautilus)$"
      "opacity 0.80 0.70, class:^(nm-connection-editor)$"
      "opacity 0.80 0.70, class:^(vesktop)$"
      "opacity 0.80 0.70, title:^(Spotify( Premium)?)$"
      "opacity 0.80 0.70, initialClass:^(Cider)$"

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

      # Apple Music
      "workspace 9 silent, initialClass:^(Cider)$"
      "center, initialClass:^(Cider)$"
      "size 1920 1080, initialClass:^(Cider)$"

      # Discord
      "workspace 8 silent, class:^(vesktop)$"
      "center, class:^(vesktop)$"
      "size 1920 1080, class:^(vesktop)$"

      # Steam
      "workspace 10 silent, class:^(steam)"

      # Games
      "workspace name:Gaming, class:gamescope"
      "workspace name:Gaming, initialClass:cs2"
      "workspace name:Gaming, initialClass:^(steam_app_)(.*)"
      #"immediate, initialClass:^(steam_app_\d+|SDL Application)$"
      "immediate, initialClass:^(steam_app_)(.*)$"
      "fullscreen, initialClass:^(steam_app_)(.*)$"
      "fullscreen, initialClass:cs2"
      "renderunfocused, initialClass:^(steam_app_)(.*)^(steam_app_\d+|cs2)$"
      "float, initialTitle:Hearthstone"
      "size 1920 1080, initialTitle:Hearthstone"
      "maxsize 1920 1080, initialTitle:Hearthstone"
      "minsize 1920 1080, initialTitle:Hearthstone"
      "center, initialTitle:Hearthstone"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "float, class:^(xdg-desktop-portal-gtk)$"
      "center, class:^(xdg-desktop-portal-gtk)$"
      "size 1920 1080, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # Waydroid
      "float, class:Waydroid"
    ];
  };
}

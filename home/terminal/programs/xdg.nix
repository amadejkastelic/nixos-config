{
  config,
  pkgs,
  ...
}:
let
  browser = [ "zen" ];
  fileManager = [ "org.gnome.Nautilus" ];
  archiver = [ "org.gnome.Nautilus" ];
  imageViewer = [ "org.gnome.Loupe" ];
  videoPlayer = [ "mpv" ];
  audioPlayer = [ "mpv" ];

  xdgAssociations =
    type: program: list:
    builtins.listToAttrs (
      map (e: {
        name = "${type}/${e}";
        value = program;
      }) list
    );

  image = xdgAssociations "image" imageViewer [
    "png"
    "svg"
    "jpeg"
    "gif"
  ];
  video = xdgAssociations "video" videoPlayer [
    "mp4"
    "avi"
    "mkv"
  ];
  audio = xdgAssociations "audio" audioPlayer [
    "mp3"
    "flac"
    "wav"
    "aac"
  ];
  archive = xdgAssociations "application" archiver [
    "zip"
    "x-rar"
    "gzip"
    "x-7z-compressed"
  ];
  browserTypes =
    (xdgAssociations "application" browser [
      "json"
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "ftp"
      "http"
      "https"
      "unknown"
    ]);

  # XDG MIME types
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) (
    {
      "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf" ];
      "text/html" = browser;
      "text/plain" = [ "codium" ];
      "x-scheme-handler/chrome" = [ "chromium-browser" ];
      "inode/directory" = fileManager;
      "x-scheme-handler/spotify" = [ "spotify.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop" ];
      "x-scheme-handler/steam" = [ "steam.desktop" ];
    }
    // image
    // video
    // audio
    // browserTypes
    // archive
  );
in
{
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  home.packages = [
    # used by `gio open` and xdp-gtk
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      wezterm start "$@"
    '')
    pkgs.xdg-utils
  ];
}

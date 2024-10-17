{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      # obs-vkcapture https://github.com/NixOS/nixpkgs/pull/349081
      obs-vaapi
      obs-pipewire-audio-capture
      droidcam-obs
    ];
  };
}

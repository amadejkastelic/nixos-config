{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-vaapi
      obs-pipewire-audio-capture
      droidcam-obs
    ];
  };
}

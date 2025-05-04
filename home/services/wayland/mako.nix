{
  services.mako = {
    enable = true;

    settings = {
      anchor = "top-right";
      defaultTimeout = "3000";
      borderRadius = "16";
    };
  };

  # https://github.com/catppuccin/nix/pull/553
  catppuccin.mako.enable = false;
}

{pkgs, ...}: {
  programs.waybar = {
    enable = true;

    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
  };

  catppuccin.waybar.enable = true;
}

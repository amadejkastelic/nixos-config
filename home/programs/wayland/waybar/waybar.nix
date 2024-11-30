{pkgs, ...}: {
  programs.waybar = {
    enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
  programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
  });
}

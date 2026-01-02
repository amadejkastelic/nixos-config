{
  pkgs,
  config,
  ...
}:
let
  rofi-cliphist = pkgs.writeShellScriptBin "rofi-cliphist" ''
    tmp_dir="/tmp/cliphist"
    rm -rf "$tmp_dir"

    if [[ -n "$1" ]]; then
      cliphist decode <<<"$1" | wl-copy
      exit
    fi

    mkdir -p "$tmp_dir"

    read -r -d "" prog <<EOF
    /^[0-9]+\s<meta http-equiv=/ { next }
    match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
      system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
      print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
      next
    }
    1
    EOF
    cliphist list | gawk "$prog"
  '';
in
{
  home.packages = [
    rofi-cliphist
    pkgs.rofimoji
  ];

  programs.rofi = {
    enable = true;

    terminal = "${pkgs.kitty}/bin/kitty";

    font = "JetBrainsMono Nerd Font Mono 14";
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg-col = mkLiteral "#1e1e2e";
          bg-col-light = mkLiteral "#1e1e2e";
          border-col = mkLiteral "#f5c2e7";
          selected-col = mkLiteral "#f5c2e7";
          blue = mkLiteral "#f5c2e7";
          fg-col = mkLiteral "#cdd6f4";
          fg-col2 = mkLiteral "#1e1e2e";
          grey = mkLiteral "#6c7086";
          width = 600;
          font = "JetBrainsMono Nerd Font 14";
          border-radius = 16;
        };

        "element-text, element-icon, mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        window = {
          height = mkLiteral "360px";
          border = mkLiteral "3px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        mainbox = {
          background-color = mkLiteral "@bg-col";
        };

        inputbar = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "2px";
        };

        prompt = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "3px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        textbox-prompt-colon = {
          expand = false;
          str = ":";
        };

        entry = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };

        listview = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 2;
          lines = 5;
          background-color = mkLiteral "@bg-col";
        };

        element = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
        };

        element-icon = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col2";
        };

        mode-switcher = {
          spacing = 0;
        };

        button = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };

        message = {
          background-color = mkLiteral "@bg-col-light";
          margin = mkLiteral "2px";
          padding = mkLiteral "2px";
          border-radius = mkLiteral "5px";
        };

        textbox = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 20px";
          text-color = mkLiteral "@blue";
          background-color = mkLiteral "@bg-col-light";
        };
      };
  };

  xdg.configFile."rofimoji.rc".text = ''
    action = clipboard
    skin-tone = light
    prompt = "🔍"
    clipboarder = wl-copy
    type = wtype
  '';
}

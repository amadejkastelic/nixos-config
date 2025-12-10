{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    #pkgs.mcp-nixos
    (pkgs.claude-code.overrideAttrs (oa: {
      postInstall = ''
        wrapProgram $out/bin/claude \
          --set DISABLE_AUTOUPDATER 1 \
          --unset DEV_MODE \
          --add-flags "--mcp-config ${config.home.file.".config/mcp.json".source}"
      '';
    }))
  ];

  home.file = {
    # https://docs.anthropic.com/en/docs/claude-code/settings
    ".claude/settings.json".text = builtins.toJSON {
      includeCoAuthoredBy = false;
      enableAllProjectMcpServers = true;
    };

    ".config/mcp.json".text = builtins.toJSON {
      mcpServers = {
        nixos = {
          #command = lib.getExe pkgs.mcp-nixos;
        };
      };
    };
  };
}

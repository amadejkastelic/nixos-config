{ pkgs, ... }:
{
  home.packages = [ pkgs.claude-code ];

  # https://docs.anthropic.com/en/docs/claude-code/settings
  home.file.".claude/settings.json".text = builtins.toJSON {
    includeCoAuthoredBy = false;
    enableAllProjectMcpServers = true;
  };
}

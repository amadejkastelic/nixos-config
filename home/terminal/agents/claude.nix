{
  config,
  ...
}:
{
  programs.claude-code = {
    enable = true;

    mcpServers = config.programs.mcp.servers;

    settings = {
      includeCoAuthoredBy = false;
      enableAllProjectMcpServers = true;
    };
  };
}

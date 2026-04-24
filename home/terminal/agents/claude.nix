{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.claude-code = {
    enable = true;

    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;

    mcpServers = config.programs.mcp.servers;

    settings = {
      includeCoAuthoredBy = false;
      enableAllProjectMcpServers = true;
    };
  };
}

{
  config,
  ...
}:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    settings = {
      theme = "catppuccin";
      autoupdate = false;
    };
  };

  sops.templates."opencode-auth.json" = {
    content = builtins.toJSON {
      zai-coding-plan = {
        type = "api";
        key = config.sops.placeholder.z-ai-api-token;
      };
    };
    path = "${config.xdg.dataHome}/opencode/auth.json";
  };

  sops.secrets.z-ai-api-token = { };
}

{
  config,
  ...
}:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    settings = {
      autoupdate = false;
      permission = {
        edit = "ask";
        bash = "ask";
        skill = "allow";
        doom_loop = "ask";
        external_directory = "ask";
        webfetch = "ask";
      };
      default_agent = "plan";
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

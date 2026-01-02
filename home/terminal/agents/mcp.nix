{
  lib,
  pkgs,
  ...
}:
let
  zAiBaseUrl = "https://api.z.ai/api/mcp";
  zAiAuthorization = "Bearer {env:Z_AI_API_TOKEN}";
in
{
  home.packages = with pkgs; [
    github-mcp-server
    # https://github.com/NixOS/nixpkgs/pull/475389
    # mcp-nixos
  ];

  programs.mcp = {
    enable = true;

    servers = {
      github = {
        command = lib.getExe pkgs.github-mcp-server;
        args = [
          "stdio"
          "--read-only"
          "--toolsets"
          "context,repos,issues,pull_requests,actions"
        ];
        env.GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_TOKEN}";
      };
      /*
        nixos = {
          command = lib.getExe pkgs.mcp-nixos;
        };
      */
      web-search-prime = {
        type = "remote";
        url = zAiBaseUrl + "/web_search_prime/mcp";
        headers.Authorization = zAiAuthorization;
      };
      web-reader = {
        type = "remote";
        url = zAiBaseUrl + "/web_reader/mcp";
        headers.Authorization = zAiAuthorization;
      };
      zread = {
        type = "remote";
        url = zAiBaseUrl + "/zread/mcp";
        headers.Authorization = zAiAuthorization;
      };
    };
  };
}

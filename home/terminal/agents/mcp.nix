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
  home.packages = [ pkgs.mcp-nixos ];

  programs.mcp = {
    enable = true;

    servers = {
      nixos = {
        command = lib.getExe pkgs.mcp-nixos;
      };
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

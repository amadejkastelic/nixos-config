{
  sops.secrets = {
    tailscale-auth-key = {
      sopsFile = ./secrets.yaml;
    };
  };
}

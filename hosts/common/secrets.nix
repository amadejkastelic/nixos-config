{
  sops.secrets = {
    hashed-password.sopsFile = ./secrets.yaml;
    tailscale-auth-key.sopsFile = ./secrets.yaml;
    gmail-password.sopsFile = ./secrets.yaml;
  };
}

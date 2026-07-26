{ config, pkgs, ... }:
let
  # https://github.com/NixOS/nixpkgs/pull/545340
  vaultwardenSrc = pkgs.fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = "1.37.0";
    hash = "sha256-7l9tIBCfk8DeQDtIoENnjGUzVWJM3aZxw6eA+YaktlM=";
  };

  vaultwarden = pkgs.vaultwarden.overrideAttrs {
    version = "1.37.0";
    src = vaultwardenSrc;

    cargoHash = "sha256-sza4ZQz2+QJJJ03Upt6sGXAv+1VPImN2qZHXaTSALFQ=";
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      src = vaultwardenSrc;
      hash = "sha256-sza4ZQz2+QJJJ03Upt6sGXAv+1VPImN2qZHXaTSALFQ=";
    };
  };

  webVaultSrc = pkgs.fetchFromGitHub {
    owner = "vaultwarden";
    repo = "vw_web_builds";
    tag = "v2026.6.4+0";
    hash = "sha256-Uz0wPdhTVy2yOlKWAy5phr+30NmFaIPQQh5bsiWCDLA=";
  };

  webVault = pkgs.vaultwarden.webvault.overrideAttrs (
    _: previousAttrs: {
      version = "2026.6.4+0";
      src = webVaultSrc;

      postPatch = null;
      npmDepsFetcherVersion = 3;
      npmDepsHash = "sha256-PaDxqVsq00QIKDmhDhsEbKdM4QXfXn28PgpOyZjB60k=";
      npmDeps = pkgs.fetchNpmDeps {
        src = webVaultSrc;
        hash = "sha256-PaDxqVsq00QIKDmhDhsEbKdM4QXfXn28PgpOyZjB60k=";
        fetcherVersion = 3;
      };
      env = previousAttrs.env // {
        NIX_NPM_FETCHER_VERSION = 3;
      };
    }
  );
in
{
  homelab.subdomains = [ "vaultwarden" ];
  services.vaultwarden = {
    enable = true;
    package = vaultwarden;
    webVaultPackage = webVault;

    nginx = {
      enable = true;
      hostName = "vaultwarden.${config.homelab.domain}";
    };

    environmentFile = config.sops.secrets.vaultwarden-env.path;

    dbBackend = "sqlite";
    backupDir = "${config.nas.backupDir}/vaultwarden/";

    config = {
      domain = "https://vaultwarden.${config.homelab.domain}";
      signupsAllowed = false;
      showPasswordHint = false;

      rocketAddress = "127.0.0.1";
      rocketPort = 8222;
      rocketLog = "critical";

      SMTP_HOST = "smtp.gmail.com";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";
      SMTP_FROM = "amadejkastelic7@gmail.com";
      SMTP_FROM_NAME = "Vaultwarden";
    };
  };

  sops.secrets.vaultwarden-env =
    let
      serviceConfig = config.systemd.services.vaultwarden.serviceConfig;
    in
    {
      owner = serviceConfig.User;
      group = serviceConfig.Group;
    };
}

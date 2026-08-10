{ config, ... }:
let
  domain = config.homelab.domain;
  pgUser = config.services.zitadel.postgres.user;
  pgDatabase = config.services.zitadel.postgres.database;
in
{
  homelab.subdomains = [ "auth" ];

  services.zitadel = {
    enable = true;
    tlsMode = "external";
    nginx.enable = true;
    postgres.enable = true;
    masterKeyFile = config.sops.secrets."zitadel/master-key".path;

    settings = {
      Port = 8081;
      ExternalDomain = "auth.${domain}";
      ExternalPort = 443;
      ExternalSecure = true;
      Database.postgres = {
        Host = "127.0.0.1";
        Port = 5432;
        Database = pgDatabase;
        User = {
          Username = pgUser;
          Password = pgUser;
          SSL.Mode = "disable";
        };
        Admin = {
          Username = pgUser;
          Password = pgUser;
          SSL.Mode = "disable";
        };
      };
    };

    steps = {
      FirstInstance = {
        InstanceName = "amadejk";
        DefaultLanguage = "en";
        Org = {
          Name = "amadejk";
          Human = {
            UserName = "admin@${domain}";
            FirstName = "Admin";
            LastName = "User";
            PasswordChangeRequired = false;
            Email = {
              Address = "admin@${domain}";
              Verified = true;
            };
          };
        };
      };
    };

    extraStepsPaths = [ "/run/zitadel-admin-steps.yaml" ];
  };

  systemd.services.zitadel-admin-steps = {
    description = "Render Zitadel first-instance admin password";
    before = [ "zitadel.service" ];
    wantedBy = [ "zitadel.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      pw="$(cat ${config.sops.secrets."zitadel/admin-password".path})"
      umask 077
      printf 'FirstInstance:\n  Org:\n    Human:\n      Password: "%s"\n' "$pw" > /run/zitadel-admin-steps.yaml
      chown ${config.services.zitadel.user}:${config.services.zitadel.group} /run/zitadel-admin-steps.yaml
    '';
  };

  systemd.services.zitadel = {
    after = [
      "postgresql.service"
      "zitadel-admin-steps.service"
    ];
    requires = [
      "postgresql.service"
      "zitadel-admin-steps.service"
    ];
  };

  sops.secrets."zitadel/master-key" = {
    owner = config.services.zitadel.user;
    group = config.services.zitadel.group;
  };
  sops.secrets."zitadel/admin-password" = {
    owner = config.services.zitadel.user;
    group = config.services.zitadel.group;
  };
}

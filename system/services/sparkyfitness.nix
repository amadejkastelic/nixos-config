{
  config,
  inputs,
  pkgs,
  ...
}:
let
  secretsGroup = "sparkyfitness-secrets";
in
{
  imports = [ inputs.sparkyfitness.nixosModules.sparkyfitness ];

  homelab.subdomains = [ "fitness" ];

  services.sparkyfitness = {
    enable = true;
    frontendUrl = "https://fitness.${config.homelab.domain}";
    environmentFile = config.sops.secrets.sparkyfitness-env.path;
    database.package = pkgs.postgresql_15;
    nginx.virtualHost = "fitness.${config.homelab.domain}";
    extraEnvironment = {
      SPARKY_FITNESS_ADMIN_EMAIL = "amadejkastelic7@gmail.com";
      TZ = config.time.timeZone;
    };
  };

  users.groups.${secretsGroup} = { };
  users.users = {
    postgres.extraGroups = [ secretsGroup ];
    sparkyfitness.extraGroups = [ secretsGroup ];
  };

  sops.secrets.sparkyfitness-env = {
    owner = "root";
    group = secretsGroup;
    mode = "0440";
    restartUnits = [
      "sparkyfitness-db-init.service"
      "sparkyfitness.service"
    ];
  };
}

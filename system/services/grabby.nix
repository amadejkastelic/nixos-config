{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.grabby.nixosModules.grabby ];

  services.grabby = {
    enable = true;
    logLevel = "info";
    environmentFile = config.sops.secrets.grabby-env.path;

    servers = [
      {
        serverId = "181329349167939585";
        autoEmbedChannels = [ "1459218273307721758" ];
        embedEnabled = true;
      }
    ];
  };

  sops.secrets.grabby-env = {
    owner = config.services.grabby.user;
    group = config.services.grabby.group;
  };
}

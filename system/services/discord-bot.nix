{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.discord-video-embed-bot.nixosModules.default
  ];

  # Expose the bot as a system package so we can use django shell
  environment.systemPackages = [
    inputs.discord-video-embed-bot.packages.${pkgs.system}.default
  ];

  services.discordVideoEmbedBot = {
    enable = true;

    environmentFile = config.sops.secrets.discord-video-embed-bot-secrets.path;

    db.enable = true;
    cache.enable = true;

    integrationSettings = {
      tiktok.enabled = true;
      reddit = {
        enabled = true;
        user_agent = "linux:discord_bot_dev:v0.1.1 (by /u/anon)";
      };
      twitch.enabled = true;
      instagram = {
        enabled = true;
        version = 2;
      };
      youtube.enabled = true;
      facebook = {
        enabled = true;
        tls1_2 = true;
      };
      twitter.enabled = true;
      threads.enabled = true;
      "24ur".enabled = true;
      "4chan".enabled = true;
      bluesky.enabled = true;
      truth_social.enabled = true;
      linkedin.enabled = true;
    };
  };

  sops.secrets.discord-video-embed-bot-secrets = {
    owner = config.services.discordVideoEmbedBot.user;
    group = config.services.discordVideoEmbedBot.group;
  };
}

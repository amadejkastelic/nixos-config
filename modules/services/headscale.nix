{
  config,
  lib,
  ...
}:
let
  nginxCfg = config.services.headscale.nginx;
  keyCfg = config.services.headscale.apiKey;
in
{
  options.services.headscale.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for Headscale";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "headscale.${config.homelab.domain}";
      description = "Virtual host name for the Headscale reverse proxy.";
    };
  };

  options.services.headscale.apiKey = {
    enable = lib.mkEnableOption "automatic provisioning of a Headscale API key for Headplane";

    path = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/headscale/headplane-api-key";
      description = "Path to the generated API key file, read by Headplane.";
    };
  };

  config = {
    services.nginx = lib.optionalAttrs nginxCfg.enable {
      virtualHosts."${nginxCfg.hostName}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
        proxyWebsockets = true;
      };
    };

    systemd.services.headscale-apikey = lib.mkIf keyCfg.enable {
      description = "Provision a Headscale API key for Headplane";
      after = [ "headscale.service" ];
      wantedBy = [ "headscale.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = config.services.headscale.user;
        Group = config.services.headscale.group;
      };
      script = ''
        keyFile="${keyCfg.path}"
        if [ -s "$keyFile" ]; then
          echo "headscale: API key already present, skipping"
          exit 0
        fi

        HS="${lib.getExe config.services.headscale.package}"
        CFG="${config.services.headscale.configFile}"

        i=0
        while [ "$i" -lt 60 ]; do
          if key=$("$HS" --config "$CFG" apikeys create --expiration 87600h 2>/dev/null); then
            printf '%s' "$key" | tr -d '[:space:]' > "$keyFile"
            chmod 0640 "$keyFile"
            exit 0
          fi
          i=$((i + 1))
          sleep 1
        done

        echo "headscale: could not provision API key (headscale not ready?)" >&2
        exit 1
      '';
    };
  };
}

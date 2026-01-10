let
  port = 9090;
in
{
  services.prometheus = {
    enable = true;
    enableReload = true;

    port = port;

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [ { targets = [ "localhost:9100" ]; } ];
      }
      {
        job_name = "sensors";
        static_configs = [ { targets = [ "localhost:9216" ]; } ];
      }
    ];

    exporters = {
      node.enable = true;
      systemd.enable = true;
    };
  };

  services.grafana.provision.datasources.settings.datasources = [
    {
      name = "Prometheus";
      type = "prometheus";
      url = "http://localhost:${toString port}";
      isDefault = true;
    }
  ];

  hardware.i2c.enable = true;
}

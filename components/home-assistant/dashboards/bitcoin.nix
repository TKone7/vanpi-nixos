{ pkgs, ... }: 
let
  configDir = "/var/lib/hass";
  user = "hass";
  bitcoinDashboard = (pkgs.formats.yaml {}).generate "bitcoin" {
    views = [
      {
        path = "default_view";
        title = "Bitcoin";
        sections = [
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Mempool";
                heading_style = "title";
              }
              {
                type = "glance";
                entities = [
                  {
                    entity = "sensor.mempool_hour_fee";
                    name = "Hour";
                    icon = "mdi:speedometer-slow";
                  }
                  {
                    entity = "sensor.mempool_half_hour_fee";
                    name = "Half-hour";
                    icon = "mdi:speedometer-medium";
                  }
                  {
                    entity = "sensor.mempool_fastest_fee";
                    name = "Fastest";
                    icon = "mdi:speedometer";
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  systemd.tmpfiles.rules = [
    "L+  ${configDir}/bitcoin-dashboards.yaml      0755 ${user} ${user} - ${bitcoinDashboard}"
  ];

  # important: dashboard must be named lovelace-***
  services.home-assistant.config.lovelace.dashboards."lovelace-bitcoin" = {
    mode = "yaml";
    title = "Bitcoin";
    icon = "mdi:bitcoin";
    filename = "bitcoin-dashboards.yaml";
  };
}

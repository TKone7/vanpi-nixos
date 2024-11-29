{ pkgs, ... }: 
let
  configDir = "/var/lib/hass";
  user = "hass";
  testDashboard = (pkgs.formats.yaml {}).generate "testing" {
    views = [
      {
        path = "default_view";
        title = "Home";
        cards = [
          {
            type = "weather-forecast";
            entity = "weather.forecast_ruby";
            forecast_type = "daily";
          }
        ];
      }
    ];
  };
in
{
  systemd.tmpfiles.rules = [
    "L+  ${configDir}/test-dashboards.yaml      0755 ${user} ${user} - ${testDashboard}"
  ];

  # important: dashboard must be named lovelace-***
  services.home-assistant.config.lovelace.dashboards."lovelace-test" = {
    mode = "yaml";
    title = "Test";
    filename = "test-dashboards.yaml";
  };
}

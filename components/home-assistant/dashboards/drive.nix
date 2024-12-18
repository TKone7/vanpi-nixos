{ pkgs, ... }: 
let
  configDir = "/var/lib/hass";
  user = "hass";
  driveDashboard = (pkgs.formats.yaml {}).generate "drive" {
    views = [
      {
        path = "default_view";
        title = "Driving";
        sections = [
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Grey water";
                heading_style = "title";
                icon = "mdi:waterfall";
              }
              {
                type = "button";
                icon = "mdi:webcam";
                show_name = false;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_3";
                grid_options = {
                  columns = 12;
                  rows = 2;
                };
              }
              {
                type = "horizontal-stack";
                cards = [
                  {
                    type = "button";
                    icon = "mdi:valve-open";
                    name = "Open";
                    show_name = true;
                    show_icon = true;
                    tap_action = {
                      action = "perform-action";
                      perform_action = "script.open_grey_water_valve";
                    };
                  }
                  {
                    type = "button";
                    icon = "mdi:stop-circle";
                    name = "Stop";
                    show_name = true;
                    show_icon = true;
                    tap_action = {
                      action = "perform-action";
                      perform_action = "script.stop_grey_water_valve";
                    };
                  }
                  {
                    type = "button";
                    icon = "mdi:valve-closed";
                    name = "Close";
                    show_name = true;
                    show_icon = true;
                    tap_action = {
                      action = "perform-action";
                      perform_action = "script.close_grey_water_valve";
                    };
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
    "L+  ${configDir}/drive-dashboards.yaml      0755 ${user} ${user} - ${driveDashboard}"
  ];

  # important: dashboard must be named lovelace-***
  services.home-assistant.config.lovelace.dashboards."lovelace-drive" = {
    mode = "yaml";
    title = "Drive";
    icon = "mdi:car";
    filename = "drive-dashboards.yaml";
  };
}

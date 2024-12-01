{
  imports = [
    ./test.nix
  ];

  services.home-assistant = {
    lovelaceConfig = {
      title = "My Awesome Van";
      views = [{
        title = "Home";
        badges = [
          {
            type = "entity";
            entity = "sensor.asus_ai2202_battery_level";
          }
        ];
        sections = [
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Weather";
                heading_style = "title";
              }
              {
                type = "weather-forecast";
                entity = "weather.forecast_ruby";
                forecast_type = "daily";
              }
              {
                type = "thermostat";
                entity = "climate.van_thermostat";
                features = [ { type = "climate-hvac-modes"; } ];
              }
            ];
          }
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Switches";
                heading_style = "title";
              }
              {
                type = "entities";
                entities = [
                  "switch.switch_1"
                  "switch.switch_2"
                  "switch.switch_3"
                  "switch.switch_4"
                  "switch.switch_5"
                  "switch.switch_6"
                  "switch.switch_7"
                  "switch.switch_8"
                ];
              }
            ];
          }
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Resources";
                heading_style = "title";
              }
              {
                type = "gauge";
                entity = "sensor.analogsensor_tank_2";
                name = "Fresh Water";
                unit = "%";
                needle = false;
                grid_options = {
                  columns = 6;
                  rows = "auto";
                };
              }
              {
                type = "gauge";
                entity = "sensor.analogsensor_tank_1";
                name = "Grey Water";
                unit = "%";
                needle = false;
                grid_options = {
                  columns = 6;
                  rows = "auto";
                };
                severity = {
                  green = 0;
                  yellow = 70;
                  red = 90;
                };
              }
            ];
          }
          {
            type = "grid";
            cards = [
              {
                type = "heading";
                heading = "Map";
                heading_style = "title";
              }
              {
                type = "map";
                entities = [
                  { entity = "device_tracker.vanpi_rudy"; }
                ];
                theme_mode = "auto";
                grid_options = {
                  columns = "full";
                  rows = 5;
                };
              }
            ];
          }
        ];
      }];
    };
  };
}

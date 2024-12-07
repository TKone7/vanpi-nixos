{ pkgs, ... }:
{
  imports = [
    ./test.nix
  ];

  services.home-assistant = {
    customLovelaceModules = [
      (pkgs.callPackage ../../../packages/lovelace-more-info-card.nix {})
    ];
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
                heading = "Lights";
                heading_style = "title";
              }
              {
                type = "tile";
                entity = "light.all_lights";
                name = "All lights";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "tile";
                entity = "light.dimmy_main_lights";
                name = "Overhead";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "tile";
                entity = "light.dimmy_passenger_lights";
                name = "Passenger";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "tile";
                entity = "light.dimmy_shower_lights";
                name = "Shower";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "tile";
                entity = "light.dimmy_kitchen_lights";
                name = "Kitchen";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "tile";
                entity = "light.dimmy_bed_lights";
                name = "Bed";
                features = [ { type = "light-brightness"; }];
              }
              {
                type = "heading";
                heading = "Switches";
                heading_style = "title";
              }
              {
                type = "button";
                name = "Open walve";
                icon = "mdi:water-check";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_1";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Close walve";
                icon = "mdi:water-off-outline";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_2";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Underground camera";
                icon = "mdi:webcam";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_3";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Fridge";
                icon = "mdi:fridge-industrial";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_4";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Inverter";
                icon = "mdi:power-plug-outline";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_5";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Pump";
                icon = "mdi:water-pump";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_6";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Boiler";
                icon = "mdi:water-thermometer";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_7";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
              {
                type = "button";
                name = "Miner";
                icon = "mdi:currency-btc";
                show_name = true;
                show_icon = true;
                tap_action.action = "toggle";
                entity = "switch.switch_8";
                grid_options = {
                  columns = 3;
                  rows = 2;
                };
              }
            ];
          }
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
                type = "heading";
                heading = "Climate";
                heading_style = "title";
                badges = [
                  {
                    type = "entity";
                    entity = "sensor.dimmy_dimmy_temperature";
                  }
                  {
                    type = "entity";
                    entity = "sensor.ns_panel_temperature";
                  }
                ];
              }
              {
                type = "thermostat";
                entity = "climate.van_thermostat";
                features = [ { type = "climate-hvac-modes"; } ];
              }
              {
                type = "heading";
                heading = "Fan";
                heading_style = "title";
              }
              {
                type = "custom:more-info-card";
                entity = "fan.maxxair_control_living_room_fan";
                title = "MaxxAir Fan";
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

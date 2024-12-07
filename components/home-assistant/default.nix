{ pkgs, ... }: 
let
  user = "hass";
  group = "hass";
  userDir = "/var/lib/hass";
in
{
  imports = [
    ./dashboards
    ./light-switch
    ./heater
    ./mempool
    ./ns-panel
  ];

  home-manager.users."${user}" = {
    programs.home-manager.enable = true;

    home = {
      username = user;
      homeDirectory = userDir;
      stateVersion = "24.05";
    };
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraPackages = python3Packages: with python3Packages; [
      # postgresql support
      # psycopg2
      # numpy
      # aiodhcpwatcher
      # aiodiscover
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      gpio
      (pkgs.callPackage ../../packages/mcp23017.nix {})
    ];
    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "mqtt"
      "mobile_app"
      "script"
      "automation"
      "lovelace"
      "zha"
      "history"
      "recorder"
      "forecast_solar"
    ];
    config = {
      mobile_app = {};
      history = {};
      homeassistant = {
        name = "Ruby";
        unit_system = "metric";
        latitude = 32.87336;
        longitude = 117.22743;
        elevation = 430;
        currency = "EUR";
        country = "CH";
        time_zone= "Europe/Berlin";
      };
      frontend = {
        themes = "!include_dir_merge_named themes";
      };
      recorder = {
        commit_interval = 30;
      };
      owntracks = {
        mqtt_topic = "owntracks/#";
      };
      "automation manual" = [
        {
          alias = "update ha location every hour";
          trigger = {
            platform = "time_pattern";
            hours = "*";
            minutes = "10";
          };
          action = {
            action = "script.update_ha_location";
          };
        }
      ];
      script = {
        update_ha_location = {
          description = "Updating in regular interval the home GPS location based on owntracks data";
          sequence = [
            {
              action = "homeassistant.set_location";
              data_template = {
                latitude = "{{ state_attr('device_tracker.vanpi_rudy', 'latitude') }}";
                longitude = "{{ state_attr('device_tracker.vanpi_rudy', 'longitude') }}";
              };
            }
          ];
        };
      };
      light = [
        {
          platform = "group";
          name = "All lights";
          entities = [
            "light.dimmy_passenger_lights"
            "light.dimmy_main_lights"
            "light.dimmy_kitchen_lights"
            "light.dimmy_shower_lights"
            "light.dimmy_bed_lights"
          ];
        }
      ];
      switch = [
        {
          platform = "mcp23017";
          i2c_address = 32; # TODO this is actually the hex address "0x20". maybe there is a way to convert in Nix lang
          pins = {
            "8" = "switch_1";
            "9" = "switch_2";
            "10" = "switch_3";
            "11" = "switch_4";
            "12" = "switch_5";
            "13" = "switch_6";
            "14" = "switch_7";
            "15" = "switch_8";
          };
        }
        #{
        #  platform = "gpio";
        #  switches = [
        #    { port = 10; name = "Demo Switch 10"; unique_id = "demo_switch_port_10"; invert_logic = true; }
        #    { port = 27; name = "Demo Switch 27"; unique_id = "demo_switch_port_27"; invert_logic = true; }
        #    { port = 17; name = "Demo Switch 17"; unique_id = "demo_switch_port_17"; invert_logic = true; }
        #    { port = 9; name = "Demo Switch 9"; unique_id = "demo_switch_port_9"; invert_logic = true; }
        #    { port = 11; name = "Demo Switch 11"; unique_id = "demo_switch_port_11"; invert_logic = true; }
        #    { port = 5; name = "Demo Switch 5"; unique_id = "demo_switch_port_5"; invert_logic = true; }
        #  ];
        #}
      ];
    };
  };
}

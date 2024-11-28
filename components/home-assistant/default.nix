{ pkgs, ... }: {
  services.home-assistant = {
    enable = true;
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
    ];
    config = {
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
      switch = [
        {
          platform = "mcp23017";
          i2c_address = 32; # TODO this is actually the hex address "0x20". maybe there is a way to convert in Nix lang
          pins = {
            "8" = "switch_8";
            "9" = "switch_9";
            "10" = "switch_10";
            "11" = "switch_11";
            "12" = "switch_12";
            "13" = "switch_13";
            "14" = "switch_14";
            "15" = "switch_15";
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

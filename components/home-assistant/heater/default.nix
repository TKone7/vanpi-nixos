let 
  device_id = "6ec567256aa6a7225f82173584b88cd6";
in
{
  services.home-assistant.config = {
    input_boolean = {
      thermostat_helper_toggle = {
        name = "Thermostat Helper Toggle";
        icon = "mdi:home-thermometer";
      };
    };
    climate = [{
      platform = "generic_thermostat";
      name = "Van thermostat";
      heater = "input_boolean.thermostat_helper_toggle";
      target_sensor = "sensor.ns_panel_temperature";
      min_temp = 5;
      max_temp = 25;
      away_temp = 5;
      sleep_temp = 14;
      home_temp = 20;
      ac_mode = false;
      target_temp = 15;
      cold_tolerance = 0.5;
      hot_tolerance = 0.5;
      min_cycle_duration.minutes = 10;
      initial_hvac_mode = "off";
      precision = 0.1;
    }];
    "automation manual" = [
      {
        alias = "Thermostat triggers Autoterm OFF";
        mode = "single";
        trigger = [{
          platform = "state";
          entity_id = "input_boolean.thermostat_helper_toggle";
          from = "on";
          to = "off";
          for = {
            hours = 0;
            minutes = 0;
            seconds = 15;
          };
        }];
        conditions = [];
        action = [{
          device_id = device_id;
          entity_id = "select.dieselheizung_steuerung";
          domain = "select";
          type = "select_option";
          option = "Aus";
        }];
      }
      {
        alias = "Thermostat triggers Autoterm ON";
        mode = "single";
        trigger = [{
          platform = "state";
          entity_id = "input_boolean.thermostat_helper_toggle";
          from = "off";
          to = "on";
          for = {
            hours = 0;
            minutes = 0;
            seconds = 15;
          };
        }];
        conditions = [];
        action = [
          {
            device_id = device_id;
            entity_id = "select.dieselheizung_steuerung";
            domain = "select";
            type = "select_option";
            option = "Heizen";
          }
          {
            device_id = device_id;
            entity_id = "select.dieselheizung_modus";
            domain = "select";
            type = "select_option";
            option = "Wärme + Lüftung";
          }
          {
            device_id = device_id;
            entity_id = "select.dieselheizung_leistung";
            domain = "select";
            type = "select_option";
            option = "100%";
          }
        ];
      }
      {
        alias = "Warm up in the morning (16C)";
        mode = "single";
        trigger = [{
          platform = "time";
          at = "06:00:00";
        }];
        conditions = [];
        actions = [
          {
            action = "climate.set_temperature";
            target.entity_id = "climate.van_thermostat";
            data.temperature = 16;
          }
          {
            action = "climate.set_hvac_mode";
            target.entity_id = "climate.van_thermostat";
            data.hvac_mode = "heat";
          }
        ];
      }
    ];
  };
}

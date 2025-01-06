let
  deviceId = "9768eccf13894abd7fa8ec7586cf2c79";
in
{
  services.home-assistant.config = {
    "automation manual" = [
      {
        alias = "Turn lights on";
        triggers = [
          {
            trigger = "device";
            domain = "mqtt";
            device_id = deviceId;
            subtype = "button_1_press_release";
            type = "action";
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target.entity_id = "scene.all_lights_on";
          }
        ];
      }
      {
        alias = "Turn lights off";
        triggers = [
          {
            trigger = "device";
            domain = "mqtt";
            device_id = deviceId;
            subtype = "button_1_hold_release";
            type = "action";
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target.entity_id = "scene.all_lights_off";
          }
        ];
      }
      {
        alias = "Turn passenger lights on low";
        triggers = [
          {
            trigger = "device";
            domain = "mqtt";
            device_id = deviceId;
            subtype = "button_2_press_release";
            type = "action";
          }
        ];
        actions = [
          {
            action = "light.turn_on";
            target.entity_id = [ "light.dimmy_passenger_lights"];
            data.brightness = 90;
          }
          {
            action = "light.turn_off";
            target.entity_id = [
              "light.dimmy_main_lights"
              "light.dimmy_kitchen_lights"
              "light.dimmy_shower_lights"
              "light.dimmy_bed_lights"
              "light.dimmy_other_lights_1"
              "light.dimmy_other_lights_2"
            ];
            data.brightness = 90;
          }
        ];
      }
      {
        alias = "Increase brightness";
        triggers = [
          {
            trigger = "device";
            domain = "mqtt";
            device_id = deviceId;
            subtype = "brightness_step_up";
            type = "action";
          }
        ];
        actions = [
          {
            action = "light.turn_on";
            target.entity_id = [ "light.dimmy_main_lights" "light.dimmy_passenger_lights"];
            data.brightness_step_pct = 10;
          }
        ];
      }
      {
        alias = "Decrease brightness";
        triggers = [
          {
            trigger = "device";
            domain = "mqtt";
            device_id = deviceId;
            subtype = "brightness_step_down";
            type = "action";
          }
        ];
        actions = [
          {
            action = "light.turn_on";
            target.entity_id = [ "light.dimmy_main_lights" "light.dimmy_passenger_lights"];
            data.brightness_step_pct = -10;
          }
        ];
      }
    ];
    scene = [
      {
        name = "All lights on";
        entities = {
          "light.dimmy_main_lights" = {
            state = "on";
            brightness = 177;
          };
          "light.dimmy_kitchen_lights" = {
            state = "on";
            brightness = 110;
          };
          "light.dimmy_shower_lights" = {
            state = "off";
          };
          "light.dimmy_bed_lights" = {
            state = "off";
          };
          "light.dimmy_other_lights_1" = {
            state = "off";
          };
          "light.dimmy_other_lights_2" = {
            state = "off";
          };
          "light.dimmy_passenger_lights" = {
            state = "on";
            brightness = 255;
          };
        };
      }
      {
        name = "All lights off";
        entities = {
          "light.dimmy_main_lights" = {
            state = "off";
          };
          "light.dimmy_kitchen_lights" = {
            state = "off";
          };
          "light.dimmy_shower_lights" = {
            state = "off";
          };
          "light.dimmy_bed_lights" = {
            state = "off";
          };
          "light.dimmy_other_lights_1" = {
            state = "off";
          };
          "light.dimmy_other_lights_2" = {
            state = "off";
          };
          "light.dimmy_passenger_lights" = {
            state = "off";
          };
        };
      }
    ];
  };
}

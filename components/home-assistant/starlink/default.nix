{ config, lib, pkgs, pkgs-unstable, ... }:

{
  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        "starlink-obstruction-map" = {
          image = "ghcr.io/sparky8512/starlink-grpc-tools";
          autoStart = true;
          environment = {
            MQTT_HOST = "localhost";
            MQTT_PORT = "1883";
          };
          volumes = [ "/var/lib/hass:/images:rw" ];
          cmd = [ "dish_obstruction_map.py" "-t" "60" "-u" "ff00a7ff" "/images/obstruction.png" ];
          extraOptions = [
            "--net=host"
          ];
        };
        "starlink-grpc-tools" = {
          image = "ghcr.io/sparky8512/starlink-grpc-tools";
          autoStart = true;
          environment = {
            MQTT_HOST = "localhost";
            MQTT_PORT = "1883";
          };
          cmd = [ "dish_grpc_mqtt.py" "-v" "-t" "10" "status" "location" ];
          extraOptions = [
            "--net=host"
          ];
        };
      };
    };
  };
  services.home-assistant = {
    extraComponents = [ 
      "camera"
      "local_file"
      "mqtt"
    ];
    config = {
      homeassistant.allowlist_external_dirs = [ "/var/lib/hass" ];
      mqtt = {
        sensor = [
          {
            name = "Starlink state";
            state_topic = "starlink/dish_status/ut01000000-00000000-00a57246/state";
          }
          {
            name = "Starlink currenetly obstructed";
            state_topic = "starlink/dish_status/ut01000000-00000000-00a57246/currently_obstructed";
          }
          {
            name = "Starlink obstructed seconds";
            state_topic = "starlink/dish_status/ut01000000-00000000-00a57246/seconds_obstructed";
          }
          {
            name = "Starlink obstructed fraction";
            state_topic = "starlink/dish_status/ut01000000-00000000-00a57246/fraction_obstructed";
            value_template =  "{{ ((value | float(0)) * 100) | round(0) }}";
            unit_of_measurement =  "%";
          }
          {
            name = "Starlink uptime";
            state_topic = "starlink/dish_status/ut01000000-00000000-00a57246/uptime";
            unit_of_measurement =  "s";
            state_class = "measurement";
          }
        ];
      };
      rest_command = {
        dish_stow = {
          url = "http://localhost:1880/dish/stow";
          method = "get";
        };
        dish_unstow = {
          url = "http://localhost:1880/dish/unstow";
          method = "get";
        };
        reset_obstruction_map = {
          url = "http://localhost:1880/dish/clear-obstruction-map";
          method = "get";
        };
      };
      camera = [
        {
          platform = "local_file";
          name = "obstruction_map";
          file_path = "/var/lib/hass/obstruction.png";
        }
      ];
    };
  };
}

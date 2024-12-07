{ pkgs, ... }: 
{
  imports = [
    ../blueprints
  ];
  services.home-assistant.config = {
    "automation manual" = [
      {
        alias = "NSPanel Configuration";
        use_blueprint = {
          path = "Blackymas/nspanel_blueprint.yaml";
          input = {
            # TODO put this ID in a config
            nspanel_name = "b5bb9df6d259e89d4b0b72ffc35f2a0c";
            weather_entity = "weather.forecast_ruby";
            climate = "climate.van_thermostat";
            screensaver_display_time = true; # used to be false
            right_button_entity = "scene.shower_in_the_night";
            left_button_entity = "scene.all_lights_off";
          };
        };
      }
    ];
    scene = [
      {
        name = "Shower in the night";
        entities = {
          "light.dimmy_shower_lights" = {
            state = "on";
            brightness = 76;
          };
        };
      }
    ];
  };
}

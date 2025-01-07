{
  services.home-assistant.config = {
    "automation manual" = [
      {
        description = "";
        alias = "Turn shower light on - IKEA On Off and dimming Lights";
        use_blueprint = {
          path = "ikea_tradfri.yaml";
          input = {
            remote = "sensor.tradfri_switch_action";
            lights = "light.dimmy_shower_lights";
            # helper_pause = 100;
          };
        };
      }
    ];
  };
}

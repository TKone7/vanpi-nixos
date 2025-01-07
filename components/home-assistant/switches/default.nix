
{

  services.home-assistant = {
    config = {
      homeassistant.customize = {
        "switch.switch_3" = {
          friendly_name = "camera";
        };
      };
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
      ];
    };
  };
}

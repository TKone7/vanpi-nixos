let
  url = "https://mempool.space";
in
{
  services.home-assistant.config = {
    "automation manual" = [
      {
        mode = "single";
        alias = "low bitcoin fee";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = [ "sensor.mempool_hour_fee" ];
            below = 6;
          }
        ];
        actions = [
          {
            action = "notify.persistent_notification";
            data = {
              message = "Mempool fees are low. Consider sending your transactions now.";
              title = "Low fee alert!";
            };
          }
        ];
      }
    ];
    rest = [
      {
        resource = "${url}/api/v1/fees/recommended";
        scan_interval = 60 * 10;
        sensor = [
          {
            name = "Mempool Fastest Fee";
            value_template = "{{ value_json.fastestFee }}";
          }
          {
            name = "Mempool Half Hour Fee";
            value_template = "{{ value_json.halfHourFee }}";
          }
          {
            name = "Mempool Hour Fee";
            value_template = "{{ value_json.hourFee }}";
          }
          {
            name = "Mempool Economy Fee";
            value_template = "{{ value_json.economyFee }}";
          }
          {
            name = "Mempool Minimum Fee";
            value_template = "{{ value_json.minimumFee }}";
          }
        ];
      }
    ];
  };
}

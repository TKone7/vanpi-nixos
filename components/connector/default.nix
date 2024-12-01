{ pkgs, ... }: 
let
  user = "root";
  group = "root";
  connector = pkgs.callPackage ../../packages/connector.nix {};
  logPath = "/var/lib/connector";
  config = pkgs.writeTextFile {
    name = "config";
    text = ''
      support:
      - homeassistant
      devices:
      - name: Analogsensor
        id: analogsensor
        class: ADS1115
        connection:
          type: i2c
          bus: 3
        interval: 3000
        values:
        - name: 'Tank 1'
          measure: 0+GND
          min: 300
          max: 19000
          scale: 100
          unit: "%"
        - name: 'Tank 2'
          measure: 1+GND
          min: 300
          max: 19000
          scale: 100
          unit: "%"
      - name: Dieselheizung
        id: dieselheizung
        class: Autoterm_Air_2D
        connection:
          type: serial
          port: "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_ABSCDQW2-if00-port0"
      - name: Bewegungssensor
        id: bewegungssensor
        class: MPU_6050
        connection:
          type: i2c
          bus: 3
          address: 0x69
    '';
    # - name: Temperatursensor
    # id: temperatursensor
    # class: DS18B20
    # interval: 5000
  };
in {
  # users.users.connector.isSystemUser = true;

  systemd.services.connector = {
    description = "Connector";
    after = [ "network.target" ];
    serviceConfig = {
      WorkingDirectory  = "${connector}/lib/node_modules/connector";
      Restart           = "on-failure";
      User              = "${user}";
      Group             = "${group}";
      Environment       = [
        "NODE_ENV=production"
        "CONFIG_PATH=${config}"
        "LOG_FILE=${logPath}/debug.log"
      ];
      ExecStart         = "${pkgs.nodejs}/bin/node ${connector}/lib/node_modules/connector/app.js";
      # ExecStart         = ''
      #   ${pkgs.nodejs}/bin/node --eval="console.log(process.env.CONFIG_PATH); console.log(fs.existsSync(process.env.CONFIG_PATH))";
      # '';
      # Environment=PATH=/usr/bin:/usr/local/bin
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.tmpfiles.rules = [
    "d  ${logPath}      0755 ${user} ${user} - -"
  ];
}

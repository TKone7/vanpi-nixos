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
      - name: Temperatursensor
        id: temperatursensor
        class: DS18B20
        interval: 5000
    '';
    # - name: Dieselheizung
    # id: dieselheizung
    # class: Autoterm_Air_2D
    # subscribe:
    # temperature_current: connector/device/temperatursensor/28-3c5fe38162b6/state
    # connection:
    # type: serial
    # port: "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_ABSCDQW2-if00-port0"
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

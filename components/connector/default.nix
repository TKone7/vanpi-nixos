{ pkgs, ... }: {
  users.users.connector.isNormalUser = true;

  systemd.services.connector = let
    connector = pkgs.callPackage ../../packages/connector.nix {};
    config = pkgs.writeTextFile {
      name = "config";
      text = ''
        support:
        - homeassistant
        devices:
        - name: Temperatursensor
          id: temperatursensor
          class: DS18B20
          interval: 30000
        - name: Dieselheizung
          id: dieselheizung
          class: Autoterm_Air_2D
          subscribe:
            temperature_current: connector/device/temperatursensor/28-3c5fe38162b6/state
          connection:
            type: serial
            port: "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_ABSCDQW2-if00-port0"
      '';
    };
  in {
    description = "Connector";
    after = [ "network.target" ];
    serviceConfig = {
      WorkingDirectory  = "${connector}/lib/node_modules/connector";
      Restart           = "on-failure";
      User              = "connector";
      Group             = "users";
      Environment       = [ "NODE_ENV=production" "CONFIG_PATH=${config}" ];
      ExecStart         = "${pkgs.nodejs}/bin/node ${connector}/lib/node_modules/connector/app.js";
      # ExecStart         = ''
      #   ${pkgs.nodejs}/bin/node --eval="console.log(process.env.CONFIG_PATH); console.log(fs.existsSync(process.env.CONFIG_PATH))";
      # '';
      # Environment=PATH=/usr/bin:/usr/local/bin
    };
    wantedBy = [ "multi-user.target" ];
  };
}

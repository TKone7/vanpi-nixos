{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  pkgs,
}:

buildNpmPackage rec {
  pname = "vantelligence-connector";
  version = "unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "TKone7";
    repo = "vantelligence_connector";
    rev = "fedc73679db062e2f93b6cc9b3193b580a86a02f";
    hash = "sha256-OFZqWorsFct1dGtKiLPtU2Y7Via7Z7ty7Vs0gKc4G3c=";
  };

  npmDepsHash = "sha256-PVvlPiM+jvz65PmVyqATQCmd9jSfPyetQEKuH2AUgFI=";
  dontNpmBuild = true;


  # config = pkgs.writeTextFile {
  #   name = "config";
  #   text = ''
  #     support:
  #     - homeassistant
  #     devices:
  #     - name: Dieselheizung
  #       id: dieselheizung
  #       class: Autoterm_Air_2D
  #       subscribe:
  #         temperature_current: connector/device/temperatursensor/28-3c5fe38162b6/state
  #       connection:
  #         type: serial
  #         port: "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_ABSCDQW2-if00-port0"
  #   '';
  #   destination = "/config.yaml";
  # };

  # postInstall = ''
  #   cp $config/config.yaml $out/lib/node_modules/connector/config
  # '';

  postPatch = ''
    sed -i "s/const CONFIG_FILE = '.\/config\/config.yaml'/const CONFIG_FILE = process.env.CONFIG_PATH/g" app.js
    sed -i "s/'.\/debug.log'/process.env.LOG_FILE/g" app.js
  '';

  meta = {
    description = "A MQTT connector for devices in your camper";
    homepage = "https://github.com/TKone7/vantelligence_connector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vantelligence-connector";
    platforms = lib.platforms.all;
  };
}


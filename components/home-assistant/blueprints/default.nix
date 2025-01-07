{ lib, pkgs, ... }: 
let
  nspanel_blueprint = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Blackymas/NSPanel_HA_Blueprint/refs/tags/v4.3.12/nspanel_blueprint.yaml";
    sha256 = "sha256-ciRvA2KdWXhrw9hNRaBnJwpaSqNU8CauDE9eU1GIX+0=";
  };
  # new blueprint using events for zigbee2mqtt > 2.0
  # ikea_tradfri = pkgs.fetchurl {
  #   url = "https://gist.githubusercontent.com/Cadsters/322ae7f35a84d135e3be3b0eb8a0d237/raw/0d84a0d49471e07dac44694c8fe46c158893a4e2/z2m-ikea-tradfri-dimmer-switch-on-off-and-dimming.yaml";
  #   sha256 = "sha256-py4bXUYLokxnSVEXzwAshQip8Blbqu59PNzHhuZVq1s=";
  # };
in
{
  home-manager.users.hass = {
    home.file."blueprints/automation/Blackymas/nspanel_blueprint.yaml".source = nspanel_blueprint;
    home.file."blueprints/automation/ikea_tradfri.yaml".source = ./ikea_tradfri.yaml;
  };
}

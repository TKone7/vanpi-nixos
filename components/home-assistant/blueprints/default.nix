{ lib, pkgs, ... }: 
let
  blueprint = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Blackymas/NSPanel_HA_Blueprint/refs/tags/v4.3.12/nspanel_blueprint.yaml";
    sha256 = "sha256-ciRvA2KdWXhrw9hNRaBnJwpaSqNU8CauDE9eU1GIX+0=";
  };
in
{
  home-manager.users.hass = {
    home.file."blueprints/automation/Blackymas/nspanel_blueprint.yaml".source = blueprint;
  };
}

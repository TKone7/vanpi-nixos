{ lib, pkgs, buildHomeAssistantComponent, fetchFromGitHub }:

buildHomeAssistantComponent rec {
  # use fork for now because the bus is not configurable and set to 1 by default
  # we need it to be 3 however
  owner = "jpcornil-git";
  domain = "mcp23017";
  version = "v1.2.4";

  src = fetchFromGitHub {
    owner = owner;
    repo = "HA-mcp23017";
    rev = "${version}";
    sha256 = "sha256-kLLfAzyxu91x/081tSAetRuoNXlAHdvCQdCWIQJMaKg=";
  };

  postPatch = ''
    sed -i 's/DEFAULT_I2C_BUS = 1/DEFAULT_I2C_BUS = 3/g' custom_components/mcp23017/const.py
  '';

  propagatedBuildInputs = [
    pkgs.python312Packages.smbus2
  ];

  meta = with lib; {
    description = "MCP23008/MCP23017 implementation for Home Assistant (HA)";
  };
}

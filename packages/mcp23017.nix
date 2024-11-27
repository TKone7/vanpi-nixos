{ lib, pkgs, buildHomeAssistantComponent, fetchFromGitHub }:

buildHomeAssistantComponent rec {
  # use fork for now because the bus is not configurable and set to 1 by default
  # we need it to be 3 however
  owner = "TKone7";
  domain = "mcp23017";
  version = "v1.2.4";

  src = fetchFromGitHub {
    owner = owner;
    repo = "HA-mcp23017";
    rev = "e4aae5c17b82c1b396209ddb0329459dcea52f80";
    sha256 = "sha256-6FLFgzq+5wpfzL/J7igM8pnrdueyUYDmGU7/rTlEZ/8=";
  };

  propagatedBuildInputs = [
    pkgs.python312Packages.smbus2
  ];

  meta = with lib; {
    description = "MCP23008/MCP23017 implementation for Home Assistant (HA)";
  };
}

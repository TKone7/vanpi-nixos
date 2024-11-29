{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "node-red-contrib-nmea";
  version = "unstable-2020-10-24";

  src = fetchFromGitHub {
    owner = "nootropicdesign";
    repo = "node-red-contrib-nmea";
    rev = "63f2194d3db02857fa7607ebaedcd326032a59ed";
    hash = "sha256-FjtOv5A2HRKgqZiO70llQDAkXH1GWgO+gFlKRvtPv7M=";
  };
  npmDepsHash = "sha256-3NIPSS8gLi8tH2KTalU3Y2k8BSumM4gtjBMivFCBE0I=";
  dontNpmBuild = true;

  lockFile = ./package-lock.json;
  postPatch = ''
    cp ${lockFile} package-lock.json
  '';

  meta = {
    description = "Node-RED node to parse NMEA sentences";
    homepage = "https://github.com/nootropicdesign/node-red-contrib-nmea";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "node-red-contrib-nmea";
    platforms = lib.platforms.all;
  };
}

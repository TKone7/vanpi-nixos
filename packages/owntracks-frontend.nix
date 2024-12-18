{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "frontend";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "frontend";
    rev = "v${version}";
    hash = "sha256-omNsCD6sPwPrC+PdyftGDUeZA8nOHkHkRHC+oHFC0eM=";
  };

  npmDepsHash = "sha256-sZkOvffpRoUTbIXpskuVSbX4+k1jiwIbqW4ckBwnEHM=";

  # npmBuild = "npm run build";

  installPhase = ''
    mkdir $out
    cp -r dist/ $out
  '';
}


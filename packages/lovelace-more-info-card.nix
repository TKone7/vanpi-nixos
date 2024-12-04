{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "more-info-card";
  version = "unstable-2021-06-29";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-more-info-card";
    rev = "c0a9c942851c1c5370e8de102eb96597fb845d85";
    hash = "sha256-MlUGcW4J0cp8uHHKZVO8BRfdnAARVuEnY+izfuyGmWU=";
  };

  npmDepsHash = "sha256-DMxLTtMjTCRf/0/jtLZ/PfzkZ2dB5tRk6erxUPBrfHQ=";
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v ./more-info-card.js $out/

    runHook postInstall
  '';

  # passthru.entrypoint = "mini-media-player-bundle.js";

  meta = with lib; {
    description = "Display the more-info dialot of any entity as a lovelace card";
  };
}


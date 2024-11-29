{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "node-red-contrib-grpc";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "julien-pal";
    repo = "node-red-contrib-grpc";
    rev = version;
    hash = "sha256-8QmaNsW/Uuu40ishPzwtmawyd/u1Y4v6EWfAj68r380=";
  };
  npmDepsHash = "sha256-Q9FRLWDC6nN8fW0exoBEueZ64aYOt/4dcMPOdP4A/Pk=";
  dontNpmBuild = true;

  meta = {
    description = "Node RED wrapper for gRPC";
    homepage = "https://github.com/julien-pal/node-red-contrib-grpc";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "node-red-contrib-grpc";
    platforms = lib.platforms.all;
  };
}

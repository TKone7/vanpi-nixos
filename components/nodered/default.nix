{ pkgs, lib, ... }:
let
  user = "nodered";
  group = "nodered";
  node-red-contrib-grpc = pkgs.callPackage ../../packages/node-red-contrib-grpc.nix {};
  node-red-contrib-nmea = pkgs.callPackage ../../packages/node-red-contrib-nmea {};
  userDir = "/var/lib/nodered";
in
{
  users.groups."${user}" = {};
  users.users."${user}" = {
    home = userDir;
    group = group;
    isSystemUser = true;
    createHome = true;
  };

  home-manager.users."${user}" = {
    programs.home-manager.enable = true;

    home = {
      username = user;
      homeDirectory = userDir;
      stateVersion = "24.05";
    };

    home.file."flows.json".source = ./flows.json;
    # could also define json like this:
    # (pkgs.formats.json {}).generate "flow" {
    #
    # };
  };

  services.node-red = {
    enable = true;
    user = user;
    group = group;
    userDir = userDir;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d  ${userDir}/node_modules      0755 ${user} ${user} - -"
    "L+ ${userDir}/node_modules/node-red-contrib-grpc 0755 ${user} ${group} - ${node-red-contrib-grpc}/lib/node_modules/node-red-contrib-grpc"
    "L+ ${userDir}/node_modules/node-red-contrib-nmea 0755 ${user} ${group} - ${node-red-contrib-nmea}/lib/node_modules/node-red-contrib-nmea"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "node-red-contrib-grpc"
  ];
  networking.firewall = {
    # running NMEA server endpoint
    allowedTCPPorts = [ 8500 ];
  };
}

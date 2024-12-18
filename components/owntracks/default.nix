{ pkgs, ... }:
let
  user = "owntracks";
  group = "owntracks";
  userDir = "/var/lib/owntracks";
  frontend = pkgs.callPackage ../../packages/owntracks-frontend.nix {};
  frontendConfig = pkgs.writeTextDir "config/config.js"
    ''
      // Here you can overwite the default configuration values
      // Set start date to today
      const startDateTime = new Date();
      startDateTime.setHours(0, 0, 0, 0);

      window.owntracks = window.owntracks || {};
      window.owntracks.config = {
        startDateTime,
        selectedUser: 'vanpi',
        map: {
          layers: {
            heatmap: true,
          },
        },
      };
    '';
in
{
  home-manager.users."${user}" = {
    programs.home-manager.enable = true;

    home = {
      username = user;
      homeDirectory = userDir;
      stateVersion = "24.05";
    };

  };
  users.groups."${user}" = {};
  users.users."${user}" = {
    home = userDir;
    group = group;
    isSystemUser = true;
    createHome = true;
  };
  systemd.services.otrecorder = {
    description = "OwnTracks Recorder";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type      = "simple";
      WorkingDirectory = "/";
      ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 3";
      User      = user;
      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder --doc-root ${userDir}/recorder/htdocs --viewsdir ${userDir}/recorder/htdocs/views owntracks/#";
    };
    wantedBy = [ "multi-user.target" ];
  };
  environment.etc."default/ot-recorder".text = ''
    OTR_STORAGEDIR="${userDir}/recorder/store"
  '';

  ## frontent

  services.nginx = {
    enable = true;
    upstreams.otrecorder = {
      servers = {
        "localhost:8083" = { };
      };
    };
    virtualHosts.server = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 88;
        }
      ];
      root = "${frontend}/dist"; # add output here
      locations = {
        "/api/" = {
          proxyPass = "http://otrecorder/api/";
        };
        "/ws/" = {
          proxyPass = "http://otrecorder/ws/";
          proxyWebsockets = true;
        };
        "/config/config.js" = {
          root = "${frontendConfig}/config";
          tryFiles = "/config.js =404";
        };
        "/" = {
          tryFiles = "$uri $uri/index.html";
        };
      };
    };
  };
}

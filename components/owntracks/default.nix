{ pkgs, ... }:
let
  user = "owntracks";
  group = "owntracks";
  userDir = "/var/lib/owntracks";
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
}

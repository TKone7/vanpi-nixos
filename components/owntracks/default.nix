{ pkgs, ... }:
{
  # owntracks recorder
  users.users.owntracks.isNormalUser = true;
  systemd.services.otrecorder = {
    description = "OwnTracks Recorder";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type      = "simple";
      WorkingDirectory = "/";
      ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 3";
      User      = "owntracks";
      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder owntracks/#";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

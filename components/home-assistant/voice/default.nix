{ pkgs, ... }:
{
  # seems to be already running and port (10300) is busy
  # services.wyoming.faster-whisper.servers.whisper = {
  #   enable = true; 
  #   language = "en";
  #   uri = "tcp://127.0.0.1:10300";
  # };
  services.wyoming.piper.servers.piper = {
    enable = true;
    voice = "en-us-ryan-medium";
    uri = "tcp://127.0.0.1:10200";
  };
}

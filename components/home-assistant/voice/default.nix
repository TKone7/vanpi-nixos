{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ wyoming-faster-whisper ];
}

{
  networking.firewall = {
    allowedTCPPorts = [ 1883 ];
  };
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };
}

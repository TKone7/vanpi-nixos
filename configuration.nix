{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./nixos/home-manager.nix
      ./components/connector
      ./components/mosquitto
      ./components/home-assistant
      ./components/owntracks
      ./components/nodered

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager.users.admin = import ./home.nix;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  # enable one-wire interface
  boot.kernelModules = [ "w1-gpio" ];
  hardware.deviceTree = {
    enable = true;
    filter = "*rpi-4-*.dtb";
    overlays = [
      {
        name = "w1-gpio";
        dtboFile = "${pkgs.device-tree_rpi.overlays}/w1-gpio.dtbo";
      }
    ];
  };
  # raspberry-pi-nix.board = "bcm2711";
  # raspberry-pi-nix.uboot.enable = true;
  # hardware = {
  #   raspberry-pi = {
  #     config = {
  #       all = {
  #         dt-overlays = {
  #           w1-gpio = {
  #             enable = true;
  #             params = { };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "i2c" "gpio" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsYP1MDb2p9/5fsH0J6hFUXOr9xtki/w7lhDqgx63iY0yAdPPzxoYV+bhGtoijZLwyVBnvrQDF1IZy7aj0Y6t75PjW4v7p/y+xxr1SU33fLei+OqyIptY+/sQv44dKSoMDIuhmkIj+vZfY4/+93no6z7H4ONRlybQ8+4qOMynGo8HJU6G6Iw4X1sLMMCOVZOiThJ5D+QlCvB3qp3d3JWRBP3vbMs58iTGu2zWxw3fFeJDLgpQ5031qzlI+EgZxrVusIq81MetDlb8QmUMACdm5g2t9ZRCbkPgWTSpzIr9eatQ0WgjX76HNhlLNXjeZrwj9UZcATCXB5EQrnun5UGMn7882vUf8eyT8bRa3o+Fmc36wv2cP2WlUEKysg+Z7cyRbfPtw/f6ZFNQ4dJOZ6vmeQsdw+54CWBL4JCnM5Y80524UKknMD5j5s2hgK3UYIGkZS8nwY9mdTFXYQeRYWqGOO4DNjyh0s1jYTz9UhT6ez/Wftvnv9XwrRTXATIeMGwlZTv+lquIiiMzxvFQbQaulIb8CQ6xdVO69fUupBMBcp2E8axeodYQVrIzr70Iu9y2JE/pZTOzMmZgSkYZeBOVCNKdXCdaFcAxS5ClUEoBeuEHAWyl6iQhiBpQtaRxhqN5tFzclZoIPDNWJvT7vbHLhHrGqvzJf1+f8YNZntmWpxQ== cardno:000615209828" ];
  };
  # Do not require password
  security.sudo.wheelNeedsPassword = false;

  # Define extra groups for home assistant user (hass)
  users.users.hass.extraGroups = [ "i2c" "gpio" ];

  # GPIO
  # setup group manually
  users.groups = {
    gpio = { };
  };
  # configure udev rules
  services.udev.extraRules = ''
    SUBSYSTEM=="gpio", GROUP="gpio", MODE="0660"
  '';

  # I2C
  # enable to create group and udev rules automatically
  hardware.i2c.enable = true;

  # Grant access to systemd 
  # TODO make this more generic
  systemd.services.home-assistant.serviceConfig.DeviceAllow = [
    # for GPIO
    "/dev/gpiochip0 rw"
    "/dev/gpiochip1 rw"
    # for I2C
    "/dev/i2c-0 rw"
    "/dev/i2c-1 rw"
    "/dev/i2c-2 rw"
    "/dev/i2c-3 rw"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    htop
    owntracks-recorder
    systemctl-tui
    fzf
    libraspberrypi
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

  services.cgminer.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


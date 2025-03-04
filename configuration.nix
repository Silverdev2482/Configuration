{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, agenix, ... }:

{
  users.users.silverdev2482 = {
    isNormalUser = true;
    extraGroups = [ "video" "sys" "lp" "input" "networkmanager" "wheel" "plugdev" "libvirtd" "wireshark" "syncthing" ];
  };

  time.timeZone = "US/Central";

  security = {
    sudo.wheelNeedsPassword = false;
  };
}

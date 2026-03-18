{
  config,
  pkgs,
  lib,
  inputs,
  addresses,
  ...
}:

{
  boot = {
    loader = {
      grub = {
        efiSupport = lib.mkForce false;
        device = lib.mkForce "/dev/vda";
      };
    };
  };


  security = {
    sudo.wheelNeedsPassword = false;
  };
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };
}

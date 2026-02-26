{
  config,
  pkgs,
  lib,
  inputs,
  addresses,
  ...
}:

{
  security = {
    sudo.wheelNeedsPassword = false;
  };
  network = {
    networkmanager.enable = true;
    firewall.enable = false;
  };
}

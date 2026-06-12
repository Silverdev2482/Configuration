# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  fileSystems."/home/Silverdev2482/Mount/Router-Server" = {
    device = "10.48.64.1:/srv/shares";
    fsType = "nfs";
    options = [ "proto=rdma" "vers=3" "acl" ];
  };

  nix.settings = {
    secret-key-files = [ "/etc/nix/private-key.pem" ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}

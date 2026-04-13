# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "squashfs" "loop" "overlay" ];
  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = false;
    generic-extlinux-compatible.enable = false;
  };

  users.users.Silverdev2482.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqkTEWoMAwLrRj7Ju1NDu/cKhp0yH/qywsKg57mhq0a"
  ];

  systemd.services.ping-ipv6 = {
    description = "Pings kf0nlr.radio via ipv6";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''${pkgs.iputils}/bin/ping -6 kf0nlr.radio'';
      Type = "exec";
      Restart="always";
      RestartSec="1s";
    };
    unitConfig = {
      StartLimitIntervalSec = 0;
    };
  };

  systemd.services.ping-ipv4 = {
    description = "Pings kf0nlr.radio via ipv6";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''${pkgs.iputils}/bin/ping -4 kf0nlr.radio'';
      Type = "exec";
      Restart="always";
      RestartSec="1s";
    };
    unitConfig = {
      StartLimitIntervalSec = 0;
    };
  };

  system.stateVersion = "26.05";
}

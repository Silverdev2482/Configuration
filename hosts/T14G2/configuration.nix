# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, ... }:

{
  boot = {
    extraModprobeConfig = "options thinkpad_acpi fan_control=1";
#    loader.efi.efiSysMountPoint = "/efi/EFI/";
  };



  services = {
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      extraConfig = "LidSwitchIgnoreInhibited=no";
    };
#    fprintd = {
#      enable = true;
#      tod = {
#        enable = true;
#        driver = nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
#          calib-data-file = ./config/calib-data.bin;
#        };
#      };
#    };
  };
}

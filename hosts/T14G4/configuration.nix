# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, ... }:

{
  boot = {
    extraModprobeConfig = "options thinkpad_acpi fan_control=1";
#    loader.efi.efiSysMountPoint = "/efi/EFI/";
    loader.limine = {
      extraEntries = ''
        /Windows 11
          protocol: efi
          path: uuid(f863546e-c630-46ac-a00b-ae74c5360c3c):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

#  time.timeZone = lib.mkForce "US/Mountain";


  services = {
    fprintd = {
      enable = true;
    };
  };

  networking.modemmanager = {
    enable = true;
    fccUnlockScripts = [
#      {
#       id = "8086:7560";
#       path = "/home/Silverdev2482/8086:7560-unlock.sh";
#     }
    ];
  };
  systemd.services.ModemManager = {
    wantedBy = [ "multi-user.target" ];
    scriptArgs = "--debug";
  };

  fileSystems."/home/Silverdev2482/Mount/Router-Server" = {
    device = "//10.48.0.1/shares/";
    fsType = "cifs";
    options = [ "gid=100" "uid=1000" "credentials=/home/Silverdev2482/.config/smb-secrets" "x-systemd.automount" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };


}

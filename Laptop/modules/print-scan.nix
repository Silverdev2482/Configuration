{ config, pkgs, lib, ... }:
{
  options = {
    print-scan.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.print-scan.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      brscan4.enable = true;
    };
    services = {
      ipp-usb.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };

    environment.systemPackages = with pkgs; [
      simple-scan
    ];
  };
}

{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, agenix, ... }:

{

  boot = {
    supportedFilesystems = [ "bcachefs" "cifs" "nfs" ];
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [ ];
    kernelModules = [ "i2c-dev" "ddcci-driver" ];
  };

  zramSwap.enable = true;

  time.timeZone = "US/Central";

  security = {
    polkit.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  hardware.infiniband.enable = true;

  services = {
    openssh = {
      enable = true;
    };
  };

  programs = {
    mosh.enable = true;
    fuse.userAllowOther = true;
  };

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };


  environment.systemPackages = with pkgs; [
    wgnord
    cifs-utils
    tftp-hpa
    qperf
    rdma-core
    unzip
    zip
    nix-fast-build
    irssi
    agenix.packages.${pkgs.system}.default
    sshuttle
    fastfetch
    inputs.my-nvf.packages.${pkgs.system}.default
    btop
    sshfs
    gcc
    acpi
    lm_sensors
    file
    zip
    git
    usbutils
    mosh
  ];
}

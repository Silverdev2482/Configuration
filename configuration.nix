{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, agenix, ... }:

{

  boot = {
    supportedFilesystems = [ "bcachefs" "vfat" "cifs" "nfs" ];
    loader = {
      limine = {
        enable = true;
        secureBoot.enable = true;
        maxGenerations = 8;
      };
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [ ];
    kernelModules = [ "i2c-dev" ];
    kernelPatches = [
      {
        name = "ipxlat";
        patch = ./Introducing-ipxlat-a-stateless-IPv4-IPv6-translation-device.patch;
      }
    ];
    kernelPackages = pkgs.linuxKernel.packages.linux_7_0;
    initrd = {
      systemd = {
        emergencyAccess = true;
      };
    };
  };

  networking = {
    firewall.enable = false;
    nftables.enable = true;
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
    wireshark.enable = true;
    ccache = {
      enable = true;
      packageNames = [ "linux" ];
    };
    mosh.enable = true;
    fuse.userAllowOther = true;
    zsh = {
      enable = true;
      enableCompletion = true;
    };
  };

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  nix = {
    settings = {
      extra-sandbox-paths = [ "/var/cache/ccache" ];
      trusted-users = [
        "root"
        "Silverdev2482"
      ];
      substituters = [
        "https://harmonia.services.kf0nlr.radio"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "harmonia.services.kf0nlr.radio:LxPOVFxoxpkh4+7Dvb0BGQ2Ny1Cd8ltPZlWvzao/Fco="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };



  nixpkgs.overlays = [
#    (final: prev: {
#      openldap =
#        if prev.stdenv.hostPlatform.system == "i686-linux" then
#          prev.openldap.overrideAttrs (oldAttrs: {
#            doCheck = false;
#          })
#        else
#          prev.openldap;
#    })
    (final: prev: {
      xdg-desktop-portal = prev.xdg-desktop-portal.overrideAttrs (old: {
        doCheck = false;
      });
    })
    (final: prev: {
      linuxKernel = prev.linuxKernel // {
        packages = builtins.mapAttrs (name: lp:
          lp.extend (lpFinal: lpPrev: {
            kernel = lpPrev.kernel.override {
              stdenv = prev.ccacheStdenv;
            };
          })
        ) prev.linuxKernel.packages;
      };
    })
  ];






  environment.systemPackages = with pkgs; [
    ripgrep
    tcpdump
    ipmitool
    sbctl
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
    inputs.rmxt.packages.${pkgs.system}.default
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

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, agenix, ... }:

{

  virtualisation = {
    vswitch.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true; # Enable networking
    networkmanager.wifi.backend = "iwd";
  };

  home-manager.backupFileExtension = "hmbak";

  print-scan.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    overlays = [
      (self: super: {
        networkmanager = super.networkmanager.overrideAttrs (old: {
          version = "1.57.4-dev";
          src = super.fetchurl {
            url = old.src.url;
            hash = "sha256-ThYPO/0YsmFSc2Qol1ZAoQb1qdtjPRg+rvxpUzKe0sA=";
          };
          buildInputs = old.buildInputs ++ [ super.libbpf ];
          nativeBuildInputs = old.nativeBuildInputs ++ [
            super.llvmPackages.clang-unwrapped
            super.bpftools
            super.llvmPackages.bintools
            super.linuxHeaders
          ];
          preBuild = (old.preBuild or "") + ''
            export CPATH="${super.linuxHeaders}/include:${super.glibc.dev}/include''${CPATH:+:$CPATH}"
          '';
          patches = [
            (super.replaceVars ./fix-paths.patch {
              inherit (super) ethtool gnused;
              runtimeShell = super.runtimeShell;
            })
          ] ++ builtins.filter (p: ! lib.hasInfix "fix-paths" (toString p)) old.patches;
        });
      })
    ];
  };

  nix = {
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };


  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    i2c.enable = true;
    rtl-sdr.enable = true;
    graphics.extraPackages = [ pkgs.mesa ];
    bluetooth.enable = true;
  };

  services = {
    tailscale.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    dbus.enable = true;
    greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
	        command = "${pkgs.tuigreet}/bin/tuigreet --user-menu --remember --time --time-format %Y/%m/%d-%H:%M:%S";
	        user = "greeter";
	      };
      };
    };
#    clight.enable = true;
    logind.settings.Login = {
      handlePowerKey = "suspend";
      handlePowerKeyLongPress = "poweroff";
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

    security.pam.services = let
      rules = {
        unix = {
          enable = true;
          order = 150;
          control = lib.mkForce "sufficient";
          modulePath = "${pkgs.pam.outPath}/lib/security/pam_unix.so";
        };
        fprintd = {
          enable = config.services.fprintd.enable;
          order = 100;
          control = lib.mkForce "sufficient";
          modulePath = "${pkgs.fprintd.outPath}/lib/security/pam_fprintd.so";
        };
        wheelCheck = {
          enable = true;
          order = 50;
          control = "[default=1 success=ignore]";
          modulePath = "${pkgs.pam.outPath}/lib/security/pam_succeed_if.so";
          args = [
            "user"
            "ingroup"
            "wheel"
          ];
        };
      };
    in {
      login.rules.auth = rules;
      hyprlock.rules.auth = rules;
      polkit-1.rules.auth = rules;
    };



  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
#      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
  };

  programs = {
    appimage.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      # set the flake package
#      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
#      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    coolercontrol.enable = true;
    calls.enable = true;
    wireshark = {
      package = pkgs.wireshark;
    };
    steam.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    
    ipmitool
    virt-manager
    tuigreet
    networkmanagerapplet
    fuse
    ntfs3g
    gnome-contacts
    kdePackages.partitionmanager
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    hyprpaper
    # CLI/TUI Tools

    gnumake
    opentrack
    aitrack

    chatty
    pkgsi686Linux.gperftools

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

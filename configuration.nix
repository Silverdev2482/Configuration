# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, hyprland, ... }:

{
  virtualisation = {
    waydroid.enable = true;
    libvirtd.enable = true;
  };

  # Bootloader
  boot = {
    supportedFilesystems = [ "bcachefs" "cifs" ];
    loader = {
      grub = {
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [ ];
    kernelModules = [ "i2c-dev" "ddcci-driver" ];
  };

  zramSwap.enable = true;

  networking = {
    hostName = "Desktop-SD"; # Define your hostname.
    networkmanager.enable = true; # Enable networking
#    networkmanager.wifi.backend = "iwd";

  };
  systemd.services.ModemManager = {
    wantedBy = [ "multi-user.target" ];
    scriptArgs = "--debug";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.silverdev2482 = {
    password = "test";
    isNormalUser = true;
    extraGroups = [ "video" "sys" "lp" "input" "networkmanager" "wheel" "plugdev" "libvirtd" "wireshark" "syncthing" ];
  };

  home-manager.backupFileExtension = "hmbak";

  location.provider = "geoclue2";

  time.timeZone = "US/Central";

  print-scan.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
      rocmSupport = true;
    };
    overlays = [
      (self: super: {
        eww = super.eww.override {
         withWayland = true;
        };
      })
    ];
  };


  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
    graphics.extraPackages = [ pkgs.mesa.drivers ];
    bluetooth.enable = true;
  };

  #	i18n.defaultLocale = "en_US.utf8";
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
    options = "ctrl:swap_rwin_rctrl";
  };
  
  fileSystems."/home/silverdev2482/Mount/Router-Server" = {
    device = "//10.48.0.1/shares/";
    fsType = "cifs";
    options = [ "gid=100" "uid=1000" "credentials=/home/silverdev2482/.config/smb-secrets" "x-systemd.automount" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };

  services = {
    kanata.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    dbus.enable = true;
    openssh = {
      enable = true;
    };
    greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
	        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --time --time-format %Y/%m/%d-%H:%M:%S -c Hyprland";
	        user = "greeter";
	      };
      };
    };
#    clight.enable = true;
    blueman.enable = true;
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      extraConfig = "LidSwitchIgnoreInhibited=no";
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

  xdg.portal.config.common.default = "*";
  xdg.portal.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
#    coolercontrol.enable = true;
    fuse.userAllowOther = true;
    calls.enable = true;
    wireshark.enable = true;
    steam.enable = true;
    dconf.enable = true;
    mosh.enable = true;
  };

  environment.systemPackages = with pkgs; [

    inputs.my-nvf.packages.x86_64-linux.default
    wgnord
    cifs-utils
    linux-wifi-hotspot
    greetd.tuigreet
    networkmanagerapplet
    fuse
    ntfs3g
    gnome-contacts
    polkit-kde-agent
    partition-manager
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    hyprpaper
    # CLI/TUI Tools

    neovim
    btop
    sshfs
    gcc
    acpi
    lm_sensors
    file
    mosh
    tftp-hpa
    unzip
    git
    zip
    usbutils
    gnumake
    glxinfo

    chatty
    pkgsi686Linux.gperftools

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

}

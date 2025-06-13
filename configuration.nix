{ inputs, config, pkgs, lib, nixos-06cb-009a-fingerprint-sensor, home-manager, agenix, ... }:

{
  users.users.silverdev2482 = {
    isNormalUser = true;
    extraGroups = [ "video" "sys" "lp" "input" "networkmanager" "wheel" "plugdev" "libvirtd" "wireshark" "syncthing" "dialout" ];
  };

  time.timeZone = "US/Central";

  security = {
    sudo.wheelNeedsPassword = false;
  };

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
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

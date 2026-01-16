{ inputs, config, pkgs, lib, agenix, ... }:
{
  users = {
    mutableUsers = true;

    users = {
      Silverdev2482 = {
        isNormalUser = true;
        extraGroups = [
          "video"
          "sys"
          "lp"
          "networkmanager"
          "plugdev"
          "libvirtd"
          "dialout"
          "rdma"
          "wheel"
          "minecraft"
          "share"
          "nginx"
        ];
        hashedPasswordFile = config.age.secrets.user-password.path;
      };

      Julie = {
        isNormalUser = true;
        extraGroups = [
          "share"
          "holub"
        ];
      };

      royalspade = {
        isNormalUser = true;
        extraGroups = [ "share" ];
      };
      stuffedcrust = {
        isNormalUser = true;
        extraGroups = [ "share" ];
      };
      joey = {
        isNormalUser = true;
        extraGroups = [ "share" ];
      };

      Astraeus = {
        isNormalUser = true;
        extraGroups = [ "share" ];
      };

      TheRealmer = {
        isNormalUser = true;
        extraGroups = [
          "minecraft"
          "share"
        ];
      };

      share = {
        isSystemUser = true;
        group = "share";
      };
      borg = {
        isSystemUser = true;
        group = "share";
      };
      qbittorrent = {
        isSystemUser = true;
        group = "qbittorrent";
        extraGroups = [ "share" ];
      };
      jellyfin = {
        isSystemUser = true;
        group = "jellyfin";
        extraGroups = [ "share" ];
      };
    };


    groups = {
      share = {
        gid = 994;
      };
      guest = { };
      holub = { };

      qbittorrent = { };
      nginx = { };
      jellyfin = { };
    };
  };
}

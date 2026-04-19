{ inputs, config, pkgs, lib, ... }:

{
  #idk

  home.file = {
    ".config/hypr/hyprpaper.conf".source = ../../modules/hyprland/hyprpaper-1920x1200-jpg.conf;
  };
}

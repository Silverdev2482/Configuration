{ inputs, config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # TUI/CLI Tools and applications or any GUI application normally invoked from the command line

  ];


  home.file = {
    ".config/hypr/hyprpaper.conf".source = ../../modules/hyprland/hyprpaper-1920x1080-png.conf;
  };
}

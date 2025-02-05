{ inputs, config, pkgs, hyprland, hostname, ... }: {
  home.packages = with pkgs; [ hyprpolkitagent hyprpaper dunst waybar ];
  systemd.user.targets.graphical-session.Unit.Wants = [ "hyprpolkitagent.service" "hyprpaper.service" "dunst.service" "waybar.service" ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ../../modules/hyprland/hyprland-generic.conf) + (builtins.readFile ../../modules/hyprland/hyprland-${hostname}.conf);
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd.enable = false;
  };
}

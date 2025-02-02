{ inputs, config, pkgs, hyprland, hostname, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ../../modules/hyprland/hyprland-generic.conf) + (builtins.readFile ../../modules/hyprland/hyprland-${hostname}.conf);
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}

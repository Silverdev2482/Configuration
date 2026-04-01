{ inputs, lib, pkgs, config, ... }:
{
  options = {
    games.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      steam
      supertux
      supertuxkart
      prismlauncher
      inputs.elyprismlauncher.packages.${pkgs.system}.prismlauncher
      lutris
      protonup-qt
    ];
  };
}

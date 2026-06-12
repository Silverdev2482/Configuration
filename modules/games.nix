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
      protonup-qt
      (pkgs.lutris.override {
      # Intercept buildFHSEnv to modify target packages
      buildFHSEnv = args: pkgs.buildFHSEnv (args // {
        multiPkgs = envPkgs:
          let
            # Fetch original package list
            originalPkgs = args.multiPkgs envPkgs;

            # Disable tests for openldap
            customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
          in
            # Replace broken openldap with the custom one
            builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
        });
      })
    ];
  };
}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stardustxr.url = "github:StardustXR/server";
    fan.url = "github:Silverdev2482/fan";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nvf.url = "github:silverdev2482/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    fan,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    nixosConfigurations = let
      mkHost = {
        system,
        hostname,
        modules ? [],
        username,
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs hostname;};
          modules =
            [
              ./hosts/${hostname}
              ./modules
              ./modules/kanata
              ./configuration.nix
              home-manager.nixosModules.home-manager
              {
                networking.hostName = hostname;
                home-manager = {
                  extraSpecialArgs = {inherit inputs hostname;};
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = {
                    imports = [
                      ./hosts/${hostname}/home.nix
                      ./modules/games.nix
                      ./modules/hyprland
                    ];
                  };
                };
              }
            ]
            ++ modules;
        };
    in
      builtins.mapAttrs (hostname: system: mkHost (system // {inherit hostname;})) {
        Desktop-SD = {
          inherit system;
          username = "silverdev2482";
        };
        T480 = {
          inherit system;
          username = "silverdev2482";
          modules = [];
        };
      };
  };
}

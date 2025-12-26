{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stardustxr.url = "github:StardustXR/server";
    fan.url = "github:Silverdev2482/fan";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    agenix.url = "github:ryantm/agenix";
    my-nvf.url = "github:silverdev2482/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openthreadboarderrouterinitpatch = {
      url = "https://github.com/nixos/nixpkgs/pull/332296.patch";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
 #   hyprland,
    fan,
    ...
  } @ inputs: let
#    system = "x86_64-linux";
  in {
#    formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    nixosConfigurations = let
      mkHost = {
        system ? "x86_64-linux",
        modules ? [],
        type ? "workstation",
        username ? "Silverdev2482",
        hostname,
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs hostname agenix;};
          modules =
            [
              ./hosts/${hostname}
              ./modules
              ./configuration.nix
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              {
                networking.hostName = hostname;
              }
            ]
            ++ nixpkgs.lib.optionals ( type == "workstation" ) [
              ./workstation.nix
              {
                home-manager = {
                  extraSpecialArgs = {inherit inputs hostname username;};
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = {
                    imports = [
                      ./home.nix
                      ./hosts/${hostname}/home.nix
                      ./modules/games.nix
                      ./modules/hyprland/home.nix
                    ];
                  };
                };
              }
            ]
            ++ modules;
        };
    in
      builtins.mapAttrs (hostname: system: mkHost (system // {inherit hostname system;})) {
        Desktop-SD = {
        };
        T14G2 = {
        };
        T480 = {
          modules = [];
        };
        Router-Server = {
          type = "server";
        };
      };
  };
}

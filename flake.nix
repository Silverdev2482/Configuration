{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/unstable";
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

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hyprland
    , fan
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      nixosConfigurations = {
        let
        mkHost = { system, hostname }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialAgs = { inherit inputs; };
          modules = [ 
            ./hosts/${hostname}
            {
              networking.hostname = hostname;
            }
          ]
        };
        in
        builtins.mapAttrs ( system: hostname: mkHost ( system // { hostname = hostname; } )) {
          Desktop-SD = {
            modules = [
              ./hardware-configuration.nix
              ./configuration.nix
              ./modules
              home-manager.nixosModules.home-manager
              {
               home-manager = {
                  extraSpecialArgs = { inherit inputs; };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.silverdev2482 = {
                    imports = [
                      ./home.nix
                      ./modules/games.nix
                    ];
                  };
                };
              }
            ];
          };
        };
        T480 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            ./modules
            home-manager.nixosModules.home-manager
            {
             home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.silverdev2482 = {
                  imports = [
                    ./home.nix
                    ./modules/games.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs-unpatched.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unpatched";
    };
    agenix.url = "github:ryantm/agenix";

    nixos-router.url = "github:chayleaf/nixos-router";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";


    openThreadBoarderRouterInitPatch = {
      url = "https://github.com/nixos/nixpkgs/pull/332296.patch";
      flake = false;
    };

    fan.url = "github:Silverdev2482/fan";
    my-nvf.url = "github:silverdev2482/nvf";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    stardustxr.url = "github:StardustXR/server";
    elyprismlauncher.url = "github:ElyPrismLauncher/ElyPrismLauncher";
    rmxt.url = "github:santoshxshrestha/rmxt";
  };

  outputs = { self, nixpkgs-unpatched, home-manager, agenix, fan, ... } @ inputs:
    let
      system = "x86_64-linux";

      nixpkgs = (import nixpkgs-unpatched { inherit system; }).applyPatches {
        name = "nixpkgs";
        src = nixpkgs-unpatched;
        patches = [
          inputs.openThreadBoarderRouterInitPatch
        ];
      };

      pkgs = import nixpkgs { inherit system; };
      patchedNixOS = import (nixpkgs + /nixos/lib/eval-config.nix);

      mkHost = {
        system ? "x86_64-linux",
        modules ? [],
        type ? "workstation",
        username ? "Silverdev2482",
        hostname,
      }:
        patchedNixOS {
          inherit system;
          specialArgs = {
            inherit nixpkgs inputs hostname agenix;
            addresses = import ./addresses.nix;
          };
          modules =
            [
              ./hosts/${hostname}
              ./modules
              ./configuration.nix
              ./users.nix
              ./secrets/agenix.nix
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              inputs.nixos-router.nixosModules.default
              inputs.nix-minecraft.nixosModules.minecraft-servers
              { networking.hostName = hostname; }
            ]
            ++ pkgs.lib.optionals (type == "workstation") [
              ./workstation.nix
              {
                home-manager = {
                  extraSpecialArgs = { inherit inputs hostname username; };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username}.imports = [
                    ./home.nix
                    ./hosts/${hostname}/home.nix
                    ./modules/games.nix
                    ./modules/hyprland/home.nix
                  ];
                };
              }
            ]
            ++ pkgs.lib.optionals (type == "netboot") [
              "${nixpkgs}/nixos/modules/installer/netboot/netboot.nix"
            ]
            ++ modules;
        };
    in
    {
      # formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      nixosConfigurations = builtins.mapAttrs
        (hostname: hostConfig: mkHost (hostConfig // { inherit hostname; }))
        {
          Desktop-SD = { };
          T14G4 = { };
          T480 = { modules = []; };
          Router-Server = { type = "server"; };
          VPN-VPS = { type = "server"; };
          Netboot = {
            type = "netboot";
          };
        };
    
      Netboot =
        let
          sys = (mkHost { hostname = "Netboot"; type = "netboot"; }).config.system.build;
        in
        pkgs.symlinkJoin {
          name = "Netboot";
          paths = [
            sys.kernel
            sys.netbootRamdisk
            sys.netbootIpxeScript
          ];
        };
    };
}

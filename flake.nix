{
  description = "System configuration of Seungheon Oh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Overlays, etc
    comma = { url = "github:Shopify/comma"; flake = false; };
  };

  outputs = { self, darwin, home-manager, nixpkgs, ... }@inputs:
  let
    nixpkgsConfig = {
      config = { 
        allowUnfree = true; 
        packageOverrides = import ./pkgs ;
      };
      overlays = [
        ( final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        })
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
          sha256 = "1cy8z8hmd6gsq7x47xzxk6bgi2qxizikhk0b9j5382pp02hz0wg3";
        }))
      ];
    };
  in {
    darwinConfigurations = {
      bootstrap = darwin.lib.darwinSystem {
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };

      SeungheonOhsAir = darwin.lib.darwinSystem {
        modules = [ 
          ./modules
          ./darwin/modules
          ./darwin
          home-manager.darwinModules.home-manager
          # From malob/nixpkgs 
          ( { config, lib, ... }: let inherit (config.users) primaryUser; in {
            nixpkgs = nixpkgsConfig;
            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
            # `home-manager` config
            users.users.${primaryUser}.home = "/Users/${primaryUser}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser} = import ./home;
          })
          
          {
            users.primaryUser = "seungheonoh";
            networking.hostName = "SeungheonOhsAir";
          }
        ];
      };
    };
  };
}
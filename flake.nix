{
  description = "System configuration of Seungheon Oh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin-nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Overlays, etc
    comma = { url = "github:Shopify/comma"; flake = false; };
  };

  outputs = { self, darwin, home-manager, nixpkgs, ... }@inputs:
  let
    # Nixpkgs configurations. Custom packages and Overlays go here.
    nixpkgsConfig = {
      config = { 
        allowUnfree = true; 
        packageOverrides = import ./pkgs ;
      };
      overlays = [
        ( final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        })
        # nvim-nightly
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
          sha256 = "003zarigbrwznfrj9byzmnclbpq8bcqiqf8ym7pw1ffdxrjsszyh";
        }))
      ];
    };
    # Common Modules for all systems
    commonModules = [
      ./modules
      {
        nixpkgs = nixpkgsConfig;
      }
    ];
    # Common configurations for Home Manager.
    homeManagerConfigurations =
      ({config, lib, ...}: {
        users.users.${config.users.primaryUser}.home = config.users.primaryUserHome;
        home-manager.useGlobalPkgs = true;
        home-manager.users.${config.users.primaryUser} = import ./home;
      });
  in {
    # NixOS Systems
    nixosConfigurations = {
      bootstrap = nixpkgs.lib.nixosSystem {
        modules = [ ./linux/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };

      cL7AySgCX3 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = commonModules ++ [
          ./linux/modules 
          ./linux
          ./linux/hardware/cL7AySgCX3.nix 
          
          home-manager.nixosModules.home-manager
          homeManagerConfigurations

          {
            users.primaryUser = "seungheonoh";
            users.primaryUserHome = "/home/seungheonoh";

            networking.hostName = "cL7AySgCX3";
            networking.interfaces = {
              enp4s0.useDHCP = true;
            };
            time.timeZone = "America/Chicago";
            
            features.v4l2loopback.enable = true;
            
            users.users.seungheonoh = {
              name = "seungheonoh";
              isNormalUser = true;
              home = "/home/seungheonoh";
              extraGroups = [ "wheel" "audio" "networkmanager" "video" "dialout" "tty" "influxdb" "libvirtd" "docker"];
            };
          }
        ];
      };
    };

    # Darwin Systems
    darwinConfigurations = {
      bootstrap = darwin.lib.darwinSystem {
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };
      
      SeungheonOhsAir = darwin.lib.darwinSystem {
        modules = commonModules ++ [ 
          ./darwin/modules
          ./darwin

          home-manager.darwinModules.home-manager
          homeManagerConfigurations

          {
            users.primaryUser = "seungheonoh";
            users.primaryUserHome = "/Users/seungheonoh";
            networking.hostName = "SeungheonOhsAir";
          }
        ];
      };
    };
  };
}

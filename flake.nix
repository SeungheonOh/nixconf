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
        # nvim-nightly
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
          sha256 = "003zarigbrwznfrj9byzmnclbpq8bcqiqf8ym7pw1ffdxrjsszyh";
        }))
      ];
    };
  in {
    # NixOS Systems
    nixosConfigurations = {
      bootstrap = nixpkgs.lib.nixosSystem {
        modules = [ ./linux/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };

      cL7AySgCX3 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules
          ./linux/modules
          ./linux
          ./linux/hardware/cL7AySgCX3.nix 
          home-manager.darwinModules.home-manager
          # From malob/nixpkgs 
          ( { config, lib, ... }: let inherit (config.users) primaryUser; in {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser} = import ./home;
          })
          {
            users.primaryUser = "seungheonoh";
            networking.hostName = "cL7AySgCX3";
            networking.interfaces = {
              enp4s0.useDHCP = true;
            };
            time.timeZone = "America/Chicago";
            
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
{lib, home-manager, ...}:

with lib;
let
  cfg = config.features.homemanager;
{
  options.features.homemanager = {
    enable = mkEnableOption "homemanager";
    primaryUser = mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
      Primary user name
      '';
    };
    primaryUserHome = mkOption {
      default = null;
      type = with lib.types; nullOr str;
      description = ''
      Primary user home directory
      '';
    };
  };
  
  config = 
    if cfg.primaryUser == null then
      throw "features.homemanager.primaryUser is required to enable homemanager";
    else 
      mkIf cfg.enable {
        users.users.${cfg.primaryUser}.home = cfg.primaryUserHome;
        home-manager = {
            useGlobalPkgs = true;
            users.${cfg.primaryUser} = import ../home;
        };
        
      };

  if stdenv.isDarwin then
    home-manager.darwinMdoules.home-manager
  else
    home-manager.nixosModules.home-manager
}
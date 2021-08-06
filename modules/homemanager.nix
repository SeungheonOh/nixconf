{config, lib, ...}:

with lib;
let
  cfg = config.features.homemanager;
in
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
  
  config = mkIf cfg.enable (
    mkAssert (cfg.primaryUser != null) "Set features.homemanager.primaryUserHome" {
      users.users.${cfg.primaryUser}.home = cfg.primaryUserHome;
      home-manager = {
          useGlobalPkgs = true;
          users.${cfg.primaryUser} = import ../home;
      };
    }
  );
}
{ lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  options = {
    users.primaryUser = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    users.primaryUserHome = mkOption {
      type = with types; nullOr string;
      default = null;
    };
  };
}
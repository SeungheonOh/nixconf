{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.features.xmonad;
in
{
  options.features.xmonad.enable = mkEnableOption "xmonad";
  
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager.gnome.enable = true;

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };
}  
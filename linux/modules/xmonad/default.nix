{config, lib, pkgs, ...}:

with lib;
let 
  cfg = config.features.xmonad;
in
{
  options.features.xmonad = {
    enable = mkEnableOption "xmonad";
    config = mkOption {
        default = ./cfg/xmonad.hs;
        type = with lib.types; nullOr (either path str);
        description = ''
        Xmonad config
        '';
    };
  };
  
  config = mkIf cfg.enable (
    mkAssert (config.features.homemanager.enable != false) "This feature uses homemanager. Enable homemanager." {
      environment.systemPackages = with pkgs; [ haskellPackages.xmobar ];

      services = {
        xserver = {
          enable = true;
          desktopManager.gnome.enable = true;

          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            config = cfg.config;
          };
        };
      };
      
      home-manager.users.${config.features.homemanager.primaryUser}.home.file.".xmobarrc" = {
        source = ./cfg/xmobarrc; 
      };
    }
  );
}  
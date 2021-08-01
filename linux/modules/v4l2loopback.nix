{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.features.v4l2loopback;
in
{
  options.features.v4l2loopback.enable = mkEnableOption "v4l2loopback";
  
  config = mkIf cfg.enable {
    boot = {
      kernelModules = [
        "v4l2loopback"
      ];
      extraModulePackages = [
        config.boot.kernelPackages.v4l2loopback
      ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 video_nr=9 card_label=a7III
      '';
    };
  };
}
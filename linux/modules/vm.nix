{config, pkgs, lib, ...}:

with lib;

let 
  cfg = config.services.vm;
in
{
  options.services.vm.enable = mkEnableOption "vm";
  
  config = mkIf cfg.enable {
    services.virtualisation = {
      libvirtd.enable = true;
    };
    environment.systemPackages = [ pkgs.virt-manager ];
  }
}
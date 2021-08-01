{config, pkgs, lib, ...}:

with lib;

let
  cfg = config.services.monitoring;
in
{
  options.services.monitoring = {
    enable = mkEnableOption "monitoring";
    port = mkOption {
      description = "Port for Grafana";
      default = 3000;
      type = types.port;
    };
    netInterface = mkOption {
      description = "Network interface to monitor";
      default = [ "enp4s0" ];
      type = types.listOf types.str;
    };
  };
  
  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        port = cfg.port;
        domain = "localhost";
        protocol = "http";
        dataDir = "/var/lib/grafana";
      };
      influxdb = {
        enable = true;
        dataDir = "/var/db/influxdb";
      };
      telegraf = {
        enable = true;
        extraConfig = {
          inputs = {
            net = { interfaces = cfg.netInterface; };
            netstat = {};
            cpu = { totalcpu = true; };
            sensors = {};
            kernel = {};
            mem = {};
            swap = {};
            processes = {};
            system = {};
            disk = {};
            diskio = {};
          };
          outputs = {
            influxdb = {
              database = "system_log";
              urls = [ "http://localhost:8086" ];
            };
          };
        };
      };
    };
    systemd.services.telegraf.path = [ pkgs.lm_sensors ];
    environment.systemPackages = with pkgs; [
      influxdb
      telegraf
    ];
  };
}
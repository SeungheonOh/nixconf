{config, lib, pkgs, ...}:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
    kernelModules = [
      "v4l2loopback"
    ];
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label=a7III
    '';
    cleanTmpDir = true;
  };
  
  # Foreign language input
  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
  
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 ];
    };
  };
  
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    fonts = with pkgs; [
      # English/Universial
      ibm-plex
      unifont
      corefonts
      iosevka
      google-fonts
      hasklig

      # Korean
      nanum-gothic-coding

      # Emojis
      noto-fonts-emoji
      noto-fonts-cjk
    ];
  };
  
  # Audio
  sound.enable = true;
  hardware = {
    pulseaudio.enable = lib.mkForce false;
    opengl.driSupport32Bit = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
    grafana = {
      enable = false;
      port = 3000;
      domain = "localhost";
      protocol = "http";
      dataDir = "/var/lib/grafana";
    };
    influxdb = {
      enable = false;
      dataDir = "/var/db/influxdb";
    };
    telegraf = {
      enable = false;
      extraConfig = {
        inputs = {
          net = { interfaces = [ "wlo1" ]; };
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
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    mpd = {
      enable = false;
      extraConfig = ''
      audio_output {
        type "pulse"
        name "pulseaudio"
        server "127.0.0.1"
      }'';
    };
  };
  systemd.services.telegraf.path = [ pkgs.lm_sensors ];

  virtualisation = {
    libvirtd.enable = false;
    docker.enable = false;
  };
  programs.dconf.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "21.05";
}
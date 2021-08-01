{ pkgs, ... }:

{
  # Networking 
  networking.knownNetworkServices = [ "Wi-Fi" ];
  networking.dns = [
    "1.1.1.1" # Cloudflare
    "8.8.8.8" # Google
  ];
  
  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    hasklig 
  ];
  
  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  security.pam.enableSudoTouchIdAuth = true;

  # Units
  system.defaults.NSGlobalDomain = {
    AppleMeasurementUnits = "Inches";
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Fahrenheit";
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    _HIHideMenuBar = true;
  };

  # Net security
  system.defaults.alf = {
    globalstate = 1;
    allowsignedenabled = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled = 1;
  };

  # Dock
  system.defaults.dock = {
    autohide = true;
    expose-group-by-app = false;
    mru-spaces = false;
  };

  # Login
  system.defaults.loginwindow = {
    GuestEnabled = false;
  };
}
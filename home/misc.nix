{config, pkgs, libs, ...}:

{
  programs = {
    htop = {
      enable = true;
      settings.show_program_path = false;
    };
    
    bat = {
      enable = true;
      config = {
        style = "plain";
      };
    };
    
    fzf = {
      enable = true;
    };
  };
  
  home.packages = with pkgs; [
    wget
    curl
    unzip
    unrar
    comma
    ag
    jq
    ffmpeg
    pot
  ] ++ lib.optionals (!stdenv.isDarwin) [
    google-chrome
    zoom-us
    discord
    feh
    wine
    
    haskell-language-server # HLS fails to build on Darwin (?)
    hlint
  ];
}
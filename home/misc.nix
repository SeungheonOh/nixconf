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
    unrar
    curl
    comma

    haskell-language-server
    haskellPackages.cabal-install
    hlint
  ];
}
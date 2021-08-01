{config, pkgs, libs, ...}:

{
  home.packages = [ pkgs.bat ];
  programs.git = {
    enable = true;
    userName = "Seungheon Oh";
    userEmail = "dan.oh0721@gmail.com";
    extraConfig = {
      core = {
        pager = "bat";
      };
    };
  };  
}
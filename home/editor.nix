{config, pkgs, libs, ...}:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./dots/vimrc;
  };
  programs.vscode = {
    # Config Sync with Github Account
    enable = true;
  };
}
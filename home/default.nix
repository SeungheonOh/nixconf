{config, pkgs, lib, ...}:

{
  imports = [
    ./editor.nix
    ./git.nix
    ./misc.nix
    ./shell.nix
  ];
}
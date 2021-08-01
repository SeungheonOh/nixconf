{config, pkgs, lib, ...}:

{
  imports = [
    ./bootstrap.nix
    ./settings.nix
  ];
}
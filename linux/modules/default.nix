{config, pkgs, libs, ...}:

{
  imports = [
    ./monitoring.nix
    ./vm.nix
    ./v4l2loopback.nix
  ];
}
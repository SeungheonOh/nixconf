{pkgs, ...}:

{
  complete-alias = pkgs.callPackage ./complete-alias.nix {};
  pot = pkgs.callPackage ./pot.nix {};
}
{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) haskellPackages;

  haskellDeps = ps: with ps; [
    base
    xmonad-contrib
    containers
  ];

  ghc = haskellPackages.ghcWithPackages haskellDeps;

  nixPackages = with pkgs; [
    ghc
    haskell-language-server
  ];
in
pkgs.stdenv.mkDerivation {
  name = "xmonad.hs";
  buildInputs = nixPackages;
}
{ lib, stdenvNoCC, fetchFromGitHub, bash, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "complete-alias";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "cykerway";
    repo = "complete-alias";
    rev = "7525b8f35796afda17ddba620a0c6edf246902b8";
    sha256 = "1s0prdnmb2qnzc8d7ddldzqa53yc10qq0lbgx2l9dzmz8pdwylyc";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -m755 complete_alias $out/bin/complete_alias
  '';

  meta = with lib; {
  };
}